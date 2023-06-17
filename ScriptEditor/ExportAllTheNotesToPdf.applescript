(function(){
'use strict'
ObjC.import('Foundation')
const currentApp = Application.currentApplication()
currentApp.includeStandardAdditions = true
const Notes = Application('Notes')
const SystemEvents = Application("System Events")

const skipPasswordProtected = false

const menuDelay = 0.7
const pasteDelay = 0.3
const exportDelay = 0.15
const clipCopyKeyDelay = 0.1

// IMPORTANT: This is JXA, not AppleScript, so change the type in the ScriptEditor window (upper left)

// WARNING
// - do not try and use the mac for other stuff when this is running, less junk gets into the clipboard...

// OK, in the output directory, we will
// - recreate the folder hierarchy as directories
// - generate a log, for debugging
// - generate a metadata json log, for posterity. This will have one JSON object per line, the user can wrap it in [] later

// Inspiration includes at least the following:
// https://jxa-examples.akjems.com
// https://forum.keyboardmaestro.com/t/how-to-use-jxa-with-system-events-app/6341/3
// https://eastmanreference.com/complete-list-of-applescript-key-codes
// https://gist.github.com/JMichaelTX/807c87319ec5efa2f9970be9e4317288 (clipboard copy delay technique)

const globals = { }
const MAX_FOLDER_DEPTH = 16
const KEY_ENTER = 36
const KEY_RETURN = 76
const KEY_TAB = 48
const KEY_CMND = 55
const KEY_SHIFT = 56
const KEY_G = 5
const KEY_ARROW_RIGHT = 124

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
		name: containerRef.name()
	}
	result.kind = getContainerKind(result)
	if (result.kind === ContainerKind.Folder) {
		result.parentRef = containerRef.container()
	} // else, accounts wont have a parent
	//console.log(JSON.stringify(result, replacer, 2))
	return result
}

const FileUtils = (function() {
	// Originally borrowed from https://forum.keyboardmaestro.com/t/why-do-we-code-jxa-scripts-using-closures/4739 and then improved
	return {
		sanitisePath(path) {
			return path.replaceAll(/[:/&<>|\*\?\\\/"']/g, "_")
		},
		fileExtension(fileName) {
			if (!fileName) return null
			const r = fileName.split('.')
			if (r.length < 2) return ""
			return r.at(-1)
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

function recordMetadata(item) {
	const s = JSON.stringify(item)
	currentApp.doShellScript(`echo '${sanitiseValue(s)}' >> '${globals.metafile}'`)
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

// Such majestic hacks needed. sigh.
// Inpsired by https://gist.github.com/JMichaelTX/807c87319ec5efa2f9970be9e4317288
const CANARY = '[None][None][None][None][None][None]'

function copyClipboard(setterFunction=null) {
	currentApp.setTheClipboardTo(CANARY)
	delay(0.1)
	if (!setterFunction) {
		SystemEvents.keystroke('a', {using: 'command down'})
		delay(clipCopyKeyDelay)
		// Copy to clipboard
		SystemEvents.keystroke('c', {using: 'command down'})
		delay(clipCopyKeyDelay)
	} else if (!setterFunction()) { return }	
	const delay_s = clipCopyKeyDelay
	let ttl = 5.0 / delay_s // seconds --> interval
	while (true) {
		const clipContents = currentApp.theClipboard()
		if (clipContents === CANARY) {
			delay(delay_s) ; ttl-- ; if (ttl <= 0) throw "Clipboard timeout"
			continue
		}
		return clipContents
	}
}

function pasteClipboard(value) {
	currentApp.setTheClipboardTo(value)
	delay(0.2)
	SystemEvents.keystroke('v', {using: 'command down'})
}

function exportPdfBySendingSystemEvents(oProcess, destDir, noteData) {
	const fileMenu = oProcess.menuBars[0].menuBarItems.byName('File')
	const exportMenu = fileMenu.menus[0].menuItems.byName('Export as PDF…')
	exportMenu.click()
	delay(menuDelay)
	
	// Copy whatever the current export suggested name is
	var clipContents
	try {
		clipContents = copyClipboard()
		if (!clipContents) throw "Invalid clipboard"
		// throw "test"
	} catch (e) {
		// Probably because they re-locked
		trace(`Clipboard failure on ${noteData.id}`)
		trace(e)
		globals.errorCount = globals.errorCount + 1
		Notes.activate()
		delay(exportDelay)
		safeCommandPress([KEY_TAB])
		delay(exportDelay)
		safeCommandPress([KEY_RETURN])
		return true
	}
	// Cmnd+Shift+g to expand the folder selector
	safeCommandPress([KEY_CMND, KEY_SHIFT, KEY_G]) // command, shift, g

	// Paste in the correct directory, then press ENTER
	pasteClipboard(destDir)
	delay(pasteDelay)
	safeCommandPress([KEY_ENTER])
	
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
	noteData.actualFilename = filePathTry
	if (paster) {
		delay(pasteDelay)
		pasteClipboard(paster)
		delay(pasteDelay)
	}
	delay(exportDelay)
	// For some reason, KEY_ENTER has stopped working (at least, since I upgraded to Ventura, but I cannot prove this)
	// It seems this new combination of activate then tab to the Save button is needed
	Notes.activate()
	delay(exportDelay)
	safeCommandPress([KEY_TAB])
	delay(exportDelay)
	safeCommandPress([KEY_RETURN])
	return true
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
				const noteId = noteRef.id()

				globals.processed.notesSeen ++
				trace(`note: id=${noteId}, name=${noteName}`)
				Progress.additionalDescription = `Note ${noteName}`
			
				const noteData = {
					noteRef: noteRef,
					id: noteId,
					name: noteName,
					created: noteRef.creationDate(),
					modified: noteRef.modificationDate(),
					passwordProtected: noteRef.passwordProtected(),
					shared: noteRef.shared(),
					attachmentCount: noteRef.attachments.length,
					parents: [getContainerInfo(noteRef.container())],
				}
				if (noteData.passwordProtected && skipPasswordProtected) {
					trace(`note: SKIP PASSWORD PROTECTED id=${noteId}, name=${noteName}`)
					continue
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
				// trace(`note.path=${notePath}`)
				noteData.path = notePath
				
				const destDir = `${globals.outputFolder}/${notePath}`
				currentApp.doShellScript(`mkdir -p '${destDir}'`)

				Notes.show(noteRef)
				//const bailOut = false
				const bailOut = !exportPdfBySendingSystemEvents(globals.oProcess, destDir, noteData)
				recordMetadata(noteData)
				if(bailOut) {
					return
				}
				// uncomment lines here to only export one note, for testing; or play with the counter
				// if (globals.processed.notesSeen >= 1) return
				// return
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
	globals.metafile = globals.outputFolder.toString() +`/metadata-${FileUtils.sanitisePath(now)}.json`
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

// Seeing as we got this far, add the square brackets and commas to the JSON file to make it a proper JSON file
currentApp.doShellScript(`sed -i '' -e '1s@^@[@' -e '2,$s@^@,@' -e '$s@$@]@' '${globals.metafile}'`)

trace(`Processed accounts=${globals.processed.accounts} folders=${globals.processed.folders} notesSeen=${globals.processed.notesSeen} errors=${globals.errorCount}`)
})()

// code: language=JXA insertSpaces=false tabSize=4


