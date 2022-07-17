(function(){
'use strict'
ObjC.import('Foundation')
const currentApp = Application.currentApplication()
currentApp.includeStandardAdditions = true
const Notes = Application('Notes')
const SystemEvents = Application("System Events")

const globals = { }
const MAX_FOLDER_DEPTH = 16

const ContainerKind = Object.freeze({
	Account: Symbol("Account"),
	Folder: Symbol("Folder"),
	Unknown: Symbol("Unknown"),
})

function replacer(k, v) {
	//console.log(`${k} ~> ${typeof v}`)
	if (typeof v === 'symbol') {
		return v.description
	}
	return v
}

function getContainerKind(item) {
	const r = item && item.id && item.id.split('/')
	if (r && r.length > 4 && r[0] === 'x-coredata:' && r[3] === 'ICAccount') {
		return ContainerKind.Account
	} else if (r && r.length > 4 && r[0] === 'x-coredata:' && r[3] === 'ICFolder') {
		return ContainerKind.Folder
	} else {
		return ContainerKind.Unknown
	}
}

function getContainerInfo(containerRef) {
	const result = {
		id: containerRef.id(),
		name: containerRef.name(),
		parentRef: null
	}
	result.kind = getContainerKind(result)
	if (result.kind === ContainerKind.Folder) {
		result.parentRef = containerRef.container()
	} // else, accounts wont have a parent
	//console.log(JSON.stringify(result, replacer, 2))
	return result
}

const FileUtils = (function() {
    return {
		sanitisePath(path) {
			return path.replaceAll(/[:/&<>|\*\?\\\/"']/g, "_")
		},
		fileExtension(fileName) {
			if (!fileName) return null
			const r = fileName.split('.')
			if (r.length < 2) return ""
			return r.reverse()[0] // this method feels rather inefficient...
		},
        fileExists: function(path) {
            const result = this.getFileOrFolderExists(path);
            return result.exists && result.isFile;
        },
        getFileOrFolderExists: function(path) {
			// console.log(`Check exists: ${path}`)
            const isDirectory = Ref();
            const exists = $.NSFileManager.defaultManager.fileExistsAtPathIsDirectory(path, isDirectory);
			// console.log(`Check exists: ${path} --> ${exists}`)
            return {
                exists: exists,
                isFile: isDirectory[0] !== 1
            };
        }
    };
})();

// Helper function to escape things that will go in shell single quote strings, that are not filenames
function sanitiseValue(s) {
	const result = !!s ? s
		.replace(/'/g, "'\"'\"'")
		.replace(/\(/g, "'\"(\"'") : s
	return result // remember, return dot lines cant break...
}

function trace(message) {
	currentApp.doShellScript(`echo '${sanitiseValue(message)}' >> '${globals.logfile}'`)
}

// We had situations where if the script is aborted or throws an exception, a key can be stuck down (like, seriously, Apple!)
// So make sure the keys all come back up, regardless of what happens
function safeCommandPress(sequence) {
	try {
		for (const s of sequence) {
			SystemEvents.keyDown(s)
		}
	} catch (e) {}
	for (const s of sequence.reverse()) {
		SystemEvents.keyUp(s)
	}	
}

function exportSlowPdf(oProcess, destDir) {
	const fileMenu = oProcess.menuBars[0].menuBarItems.byName('File')
	const exportMenu = fileMenu.menus[0].menuItems.byName('Export as PDF…')
	exportMenu.click()
	delay(0.6)
	
	// Copy whatever the current export suggested name is
	SystemEvents.keystroke('a', {using: 'command down'})
	delay(0.1)
	SystemEvents.keystroke('c', {using: 'command down'})
	delay(0.1)
	const clipContents = currentApp.theClipboard()
	
	// Cmnd+Shift+g to expand the folder selector
	safeCommandPress([55, 56, 5]) // command, shift, g

	// type in the correct directory, then press ENTER
	delay(0.2) // sigh
	for (let c of destDir) { 
		SystemEvents.keystroke(c)
		delay(0.01) // we seem to be able to cope with making this 10 msec
	}
	safeCommandPress([36])
	
	// Now combine the suggested filename with the clipboard so we can test if it already exists...
	// If it does then we will add a 'copy-1' etc before the extension...
	let destFilePath =`${destDir}/${clipContents}`
	const fr = clipContents.split('.')
	let fb = clipContents
	let ext = ''
	if (fr.length > 1) {
		fb = fr.slice(0, -1).join('.')
		ext = '.' + fr.reverse()[0]
	}
	let fn = 1
	let filePathTry = destFilePath
	let paster = null
	while (FileUtils.fileExists(filePathTry)) {
		paster = `${fb} (Copy ${fn})${ext}`
		filePathTry = Path(`${destDir}/${paster}`).toString()
		fn = fn + 1
	}
	if (paster) {
		delay(0.1)
		SystemEvents.keystroke('a', {using: 'command down'})
		delay(0.1)
		for (let c of paster) {
			SystemEvents.keystroke(c)
			delay(0.01)
		}
	}
	// And press ENTER to do it
	delay(0.05)
	safeCommandPress([36])
}

// Process all accounts connected, or (TODO) apply a filter and only process some or one
function enumerateAccounts() {
	const accountsRef = Notes.accounts
	const numAccounts = accountsRef.length
	
	globals.processed = {
		accounts: 0,
		folders: 0,
		notesSeen: 0,
	}

	for (let n=0; n < numAccounts; n++) {
		const accountRef = Notes.accounts[n]
		const accountName = accountRef.name()
		
		globals.processed.accounts ++

		trace(`Processing account.name=${accountName}`)
		Progress.description = `Account ${accountName}…`
		
		// Note that empty folders wont be seen when we do it this way
		// Perhaps there is an opportunity to optimise by computing the folder parent path once...

		const foldersRef = accountRef.folders
		const numFolders = foldersRef.length
		for (let m=0; m < numFolders; m++) {
			const folderRef = foldersRef[m]
			const folderName = folderRef.name()
			globals.processed.folders ++

			trace(`Processing account.folder.name=${folderName}`)
			Progress.description = `Account ${accountName} folder ${folderName}…`
			
			// Empirically, accessing via account.notes with a single loop, is way slower than by each notes' folder
			const notesRef = folderRef.notes
			const numNotes = notesRef.length
			for (let k=0; k < numNotes; k++) {
				const noteRef = notesRef[k]
				const noteName = noteRef.name()
				globals.processed.notesSeen ++
				trace(`note.name=${noteName}`)
				Progress.additionalDescription = `Note ${noteName}`
			
				const noteData = {
					noteRef: noteRef,
					id: noteRef.id(),
					name: noteName,
					created: noteRef.creationDate(),
					modified: noteRef.modificationDate(),
					parents: [getContainerInfo(noteRef.container())],
				}
				let n = 1
				for (; n < MAX_FOLDER_DEPTH; n++) {
					let container = getContainerInfo(noteData.parents[n-1].parentRef)
					noteData.parents.push(container)
					if (!container.parentRef) { break }
				}
				if (n > MAX_FOLDER_DEPTH) {
					throw `We cant handle a folder nest of ${MAX_FOLDER_DEPTH} layers deep!`
				}
				const notePath = noteData.parents.map(x => FileUtils.sanitisePath(x.name)).reverse().join('/')
				trace(`note.path=${notePath}`)
				trace(`note.id=${noteData.id}`)
				
				const destDir = `${globals.outputFolder}/${notePath}`
				currentApp.doShellScript(`mkdir -p '${destDir}'`)

				Notes.show(noteRef)
				
				exportSlowPdf(globals.oProcess, destDir)
			}
		}
	}
}

function start() {
	globals.exportedCount = 0
	globals.errorCount = 0
	globals.outputFolder = currentApp.chooseFolder({withPrompt:"Choose destination folder…"})
	const now = new Date().toTimeString()
	globals.logfile = globals.outputFolder.toString() +`/log-${FileUtils.sanitisePath(now)}.txt`
	trace(`Processing now=${now}`)

	Notes.activate()
	delay(0.6)
	globals.oProcess = SystemEvents.processes.whose({frontmost: true})[0]

	enumerateAccounts();
}

try {
	start()
} finally {
}

trace(`Processed accounts=${globals.processed.accounts} folders=${globals.processed.folders} notesSeen=${globals.processed.notesSeen}`)

//trace(`Processed exported=${globals.exportedCount} errors=${globals.errorCount}`)

})()

