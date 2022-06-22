// Helpful references:
// https://www.galvanist.com/posts/2020-03-28-jxa_notes/
// https://brianlovin.com/hn/31579435
// https://gist.github.com/JMichaelTX/d29adaa18088572ce6d4
// https://developer.apple.com/library/mac/releasenotes/InterapplicationCommunication/RN-JavaScriptForAutomation/Articles/OSX10-10.html
// https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/MakeaSystem-WideService.html#//apple_ref/doc/uid/TP40016239-CH46-SW1
// https://stackoverflow.com/questions/48255943/accessing-properties-of-object-using-jxa
// https://stackoverflow.com/a/48271686/2772465

// WARNING
// RUN

const currentApp = Application.currentApplication();
currentApp.includeStandardAdditions = true;

const desktopFolder = `${currentApp("desktop")}`;

const globals = { }

const GoodAttachments = ['pdf', 'heic', 'png', 'jpeg']

const Notes = Application('Notes')

try {
	start()
} finally {
	delete Notes
	delete currentApp
}

function start() {
	globals.exportedCount = 0
	globals.errorCount = 0
	globals.outputFolder = currentApp.chooseFolder({withPrompt:"Choose a folder to save exported notes to"})
	// alt: sys.pathTo("documents folder", {from: "user domain", as: "alias"}).toString() + '/blah';
	const now = new Date()
	globals.logfile = globals.outputFolder.toString() +`/log-${sanitisePath(now.toTimeString())}.txt`
	currentApp.doShellScript(`echo 'Processing now=${sanitiseValue(now.toTimeString())}' > '${globals.logfile}'`)
	enumerateAccounts();
	currentApp.doShellScript(`echo 'Processed exported=${globals.exportedCount} errors=${globals.errorCount}' > '${globals.logfile}'`)
}

// Note:
// When debugging with JSON.stringify, strip out the 'parent' objects as these will cause a recursion!
function replacer(k, v) {
	// console.log(`k=${k}, t=${typeof v}`)
	if (k === 'parent') { return undefined }
	// If necessary do additional handling to get other properties from aoNote, aoFolder, here
	return v
}

// Process all accounts connected, or apply a filter and only process some or one
function enumerateAccounts() {
	const numAccounts = Notes.accounts.length
	for (let n=0; n < numAccounts; n++) {
		const account = Notes.accounts[n]
		const accountName = account.name()
		console.log(`Account: ${accountName}`);
		//if (accountName === 'iCloud') continue

		currentApp.doShellScript(`echo 'Processing account.name=${sanitiseValue(accountName)}' >> '${globals.logfile}'`)

		Progress.description = 'Enumerating folders…'
		const tree = enumerateFolders(account)
		Progress.description = 'Enumerating notes…'
		enumerateNotes(tree)
		// console.log(JSON.stringify(tree, replacer, "  "))

		Progress.description = 'Exporting notes…'

		recurseItems(tree, 0, (item, level) => {
			processNotesInFolder(item)
		}, true)
	}
}

function processNotesInFolder(item) {
	// console.log(JSON.stringify(item.notes, replacer, "  "))
	currentApp.doShellScript(`echo 'Processing folder.name=${sanitiseValue(item.name)}' >> '${globals.logfile}'`)
		
	// Create destination folder if missing
	currentApp.doShellScript(`mkdir -p '${item.path}'`)

	// Save the notes, in various forms
	//console.log(JSON.stringify(item.notes, replacer, "  "))
	let exported = 0
	let errors = 0
	for (const note of item.notes) {
		try {
			processNote(item, note)
			exported = exported + 1
			globals.exportedCount = globals.exportedCount + 1
		} catch(e) {
			errors = errors + 1
			globals.errorCount = globals.errorCount + 1
			currentApp.doShellScript(`echo 'Error processing note ${note.id} ${sanitiseValue(e.message)}' >> '${globals.logfile}'`)			
		}
	}
	currentApp.doShellScript(`echo 'Processed folder count=${exported} errors=${errors}' >> '${globals.logfile}'`)
}

function processNote(item, note) {
	//console.log(JSON.stringify(note, replacer, "  "))
	const safeName = sanitisePath(note.name)
	const safeValue = sanitiseValue(note.name)
	const metaFile = item.path  + '/' + safeName + '.info.txt'

	console.log(safeValue)
	currentApp.doShellScript(`echo 'Exporting note id=${note.id} name=${safeValue}' >> '${globals.logfile}'`)

	Progress.additionalDescription = `Exporting ${note.name}…`

	const created = note.aoNote.creationDate()
	const updated = note.aoNote.modificationDate()
	const attachments = note.aoNote.attachments
	const numAttachments = attachments.length
	const encrypted = note.aoNote.passwordProtected()
	currentApp.doShellScript(`echo 'id=${note.id}' > '${metaFile}'`)
	currentApp.doShellScript(`echo 'parent=${note.parent.id}' >> '${metaFile}'`)
	currentApp.doShellScript(`echo 'name=${safeValue}' >> '${metaFile}'`)
	currentApp.doShellScript(`echo 'created=${created}' >> '${metaFile}'`)
	currentApp.doShellScript(`echo 'updated=${updated}' >> '${metaFile}'`)
	currentApp.doShellScript(`echo 'encrypted=${encrypted}' >> '${metaFile}'`)
	currentApp.doShellScript(`echo 'attachments=${numAttachments}' >> '${metaFile}'`)
	// TODO - handle UTF8 properly? https://bru6.de/jxa/automating-applications/notes/
	const dataFile = `${item.path}/${safeName}.html`
	dumpToFile(note.aoNote.body(), dataFile)

	const textFile = `${item.path}/${safeName}.txt`
	dumpToFile(note.aoNote.plaintext(), textFile)
	for (let v = 0; v < numAttachments; v++) {
		const att = attachments[v]
		const attachmentId = att.id()
		currentApp.doShellScript(`echo 'attachment.${v}.id=${attachmentId}' >> '${metaFile}'`)
		const attachmentName = att.name()
		const contentIdentifier = att.contentIdentifier()
		const url = att.url()
		// Convert to URL so we can get a name-id
		// x-coredata://181F2744-C17D-41B1-B66D-AA72560FF0A2/ICAttachment/p1485
		const attachmentCorePid = attachmentId.split('/').reverse()[0];
		currentApp.doShellScript(`echo 'attachment.${v}.pid=${attachmentCorePid}' >> '${metaFile}'`)			
		currentApp.doShellScript(`echo 'attachment.${v}.cid=${contentIdentifier}' >> '${metaFile}'`)
		currentApp.doShellScript(`echo 'attachment.${v}.url=${url}' >> '${metaFile}'`)
		currentApp.doShellScript(`echo 'attachment.${v}.name=${attachmentName}' >> '${metaFile}'`)

		tryHardAndSaveAttachment(item.path, `${safeName}.${attachmentCorePid}`, attachmentName, att, v, metaFile, contentIdentifier)
	}
}

// If the attachment is named, and has no extension, attempt to save it as a heic
// This function is intended to use a different filename (aka notename.attachmentpidnumber.ext instead of attachmentname.ext)
// Some images / captures seem to be like this
// If that failed, try again as a PNG
// If that failed, try again as a PDF etc. Could be audio as well, need to test
// Also the problem of an 'extension' that is not, i.e. one with a dot in an unknown extension type name
function tryHardAndSaveAttachment(path, basename, attachmentName, att, v, metaFile, cid) {
	const attachmentExt = sanitisePath(getExt(attachmentName))
	if (GoodAttachments.includes(attachmentExt || '')) {
		const attachmentFile = `${basename}.${attachmentExt}`
		currentApp.doShellScript(`echo 'attachment.${v}.file=${sanitiseValue(attachmentFile)}' >> '${metaFile}'`)
		// TODO: convert HEIC to JPEG as well
		const attachmentFilename = `${path}/${attachmentFile}`
		try {
			Notes.save(att, {in: Path(attachmentFilename)})
			return
		} catch (e) {
			currentApp.doShellScript(`echo 'Error (1) attempting to save attachment {${sanitiseValue(attachmentName)}}: ${sanitiseValue(e.message)}' >> '${globals.logfile}'`)			
		}	
	}
	currentApp.doShellScript(`echo 'Erroring / unusual attachment cid=${cid}' >> '${globals.logfile}'`)
	// try as native format:
	if (true) {
		const attachmentFile = `${basename}-native`
		currentApp.doShellScript(`echo 'attachment.${v}.file.attempt=${attachmentFile}' >> '${metaFile}'`)
		const attachmentFilename = `${path}/${attachmentFile}`
		try {
			Notes.save(att, {in: Path(attachmentFilename), as: 'native format'})
			return
		} catch (e) {
			currentApp.doShellScript(`echo 'Error (2) attempting to save attachment {${sanitiseValue(attachmentName)}}: ${sanitiseValue(e.message)}' >> '${globals.logfile}'`)			
		}
	}
	
	//Notes.show(att, {separately: true})
	
	// OK, just try a bunch of known extensions until we find one
	let worked = false
	for (const ext of GoodAttachments) {
		const attachmentFile = `${basename}.${ext}`
		currentApp.doShellScript(`echo 'attachment.${v}.file.attempt=${attachmentFile}' >> '${metaFile}'`)
		const attachmentFilename = `${path}/${attachmentFile}`
		try {
			Notes.save(att, {in: Path(attachmentFilename), as: 'native format'})
			worked = true
			break // we must have succeeded
		} catch(e) {
			currentApp.doShellScript(`echo 'Error attempting to save attachment {${sanitiseValue(attachmentName)}}: ${sanitiseValue(e.message)}' >> '${globals.logfile}'`)			
		}
	}
	if (!worked) {
	    throw new Error("Unable to save attachment") // ensure counter
	}
}

function getExt(fileName) {
	if (!fileName) return null
	const r = fileName.split('.')
	if (r.length < 2) return ""
	return r.reverse()[0]	
}

function dumpToFile(text, fileName) {
	const f = currentApp.openForAccess(Path(fileName), { writePermission: true })
    currentApp.setEof(f, { to: 0 })
	currentApp.write(text, { to: f, startingAt: currentApp.getEof(f) })
	currentApp.closeAccess(f)
}

// Helper function to escape things that will go in shell single quote strings, that are not filenames
function sanitiseValue(s) {
	const result = !!s ? s
		.replace(/'/g, "'\"'\"'")
		.replace(/\(/g, "'\"(\"'") : s

	return result // remember, return dot lines cant break...
}

// Helper function to strip out slashes and such and replace them with underscores, etc.
function sanitisePath(s) {
	//console.log(`sanitisePath s=${s}`)
	const result = !!s ? s
		.replace(/'/g, "_")
		.replace(/\*/g, "_")
		.replace(/\?/g, "_")
		.replace(/\"/g, "_")
		.replace(/\\/g, "_")
		.replace(/\//g, "_") : s

	return result // remember, return dot lines cant break...

	// This will escape a quote to _keep_ it, see https://stackoverflow.com/a/48274181/2772465
	//	.replace("'", "'\"'\"'", "g")
}

// Helper function to recursively process a tree structure
// The tree is an Array-like object, where each element may or may not have a children property
// The property children is itself an Array-like object of elements that may or may not have a children property, etc.
// The value of level should be 0 from the caller, it is incremented on each recursion
// fn() is a function to call for every item
// If descendFirst is truthy, will process the items of the items children property before calling fn() for each item
// If descendFirst is falsy, will process the items of the items children property after calling fn() for each item
function recurseItems(tree, level, fn, descendFirst) {
	for (const item of tree) {
		hasChildren = item.hasOwnProperty('children')
		if (!!descendFirst && hasChildren) {
			recurseItems(item.children, level+1, fn, descendFirst)
		}
		fn(item, level)
		if (!descendFirst && hasChildren) {
			recurseItems(item.children, level+1, fn, descendFirst)
		}
	}
}

// Helper function to create a tree object from a flat list with a length property
// fn() is called for each item in the list and returns a child node to be added to the tree
// each child node should have an id property added by fn()
// each child node should have a parentId property added by fn(), if missing is interpreted as null and thus at the root
// if the parentId alternately is same as rootId and rootId is not null then this is also treated as a root element
// This routine then adds a children[] property to the element and rearranges into a tree based on parentId
// The tree is an Array-like object, where each element may or may not have a children property
// The property children is itself an Array-like object of elements that may or may not have a children property, etc.
// Returns the generated tree
// Inspired by:
// https://medium.com/@lizhuohang.selina/building-a-hierarchical-tree-from-a-flat-list-an-easy-to-understand-solution-visualisation-19cb24bdfa33
function buildTree(list, fn, rootId) {
	const hashMap = {}
	const numItems = list.length
	for (let n=0; n < numItems; n++) {
		const element = fn(list[n])
		if (!element) { continue } // allow early filtering
		const id = element.id
		element.children = []
		if (!hashMap.hasOwnProperty(id)) {
			hashMap[id] = element
		} else {
			throw 'Should not happen (duplicate element id detected)'
		}
	}
	// console.log(JSON.stringify(hashMap, null, "  "))
	const ids = Object.getOwnPropertyNames(hashMap)
	const tree = []
	for (const k of ids) {
		if (hashMap.hasOwnProperty(k)) {
			const m = hashMap[k]
			const parentId = m.parentId || null
			if (!parentId || (!!rootId && parentId === rootId)) {
				// This item is in the root folder
				// We could optionally strip the parentId entirely, to save space...
				// m.parentId = null
				m.parent = null
				tree.push(m)
			} else {
				m.parent = hashMap[parentId]
				hashMap[parentId].children.push(m)
			}
		}
	}
	// console.log(JSON.stringify(tree, ['id', 'parentId', 'children'], "  "))
	return tree
}

// Enumerate over all folders in an account
// Create a tree of the folders, and add a filesystem-like path to each
// that we can next use to export notes to disk in the same structure
// Return the tree
function enumerateFolders(account) {
	const accountId = account.id()
	const tree = buildTree(account.folders, (folder) => {
		const folderId = folder.id()
		const folderName = folder.name()
		const parent = folder.container
		const parentId = parent.id()
		if (folderName === 'Recently Deleted') {
			return null
		}
		Progress.additionalDescription = `Inspecting ${folderName}…`
		return {
			id: folderId,
			parentId: parentId,			
			name: folderName,
			aoFolder: folder
		}
	}, accountId)
	// console.log(JSON.stringify(tree, ['name', 'parentId', 'children', 'id'], "  "))
	
	const pathPrefix = globals.outputFolder.toString() + '/' + sanitisePath(account.name())
	console.log(`pathPrefix=${pathPrefix }`)

	recurseItems(tree, 0, (item, level) => {
		// console.log(`RecurseFunction: ${level} --> ${item.name}`)
		if (level > 0) {
			// for this to work we need to descend after, so the parents path is set
			item['path'] = item.parent.path + '/' + sanitisePath(item.name)
		} else {
			item['path'] = pathPrefix + '/' + sanitisePath(item.name)
		}
	}, false);
	//console.log(JSON.stringify(tree, ['name', 'id', 'parentId', 'path', 'children'], "  "))
	return tree;
}

// Visit each folder in tree structure and gather notes as an Array on each tree item
// TODO check for duplicates, so we can change the name to suit
function enumerateNotes(tree) {	
	const Notes = Application('Notes')
	const nameIndex = {}
	recurseItems(tree, 0, (item, level) => {
		const myNotes = []
		const theNotes = item.aoFolder.notes
		const numNotes = theNotes.length
		for (let n=0; n < numNotes; n++) {
			const note = theNotes[n]
			const noteId = note.id()
			const noteName = note.name()
			const safeValue = sanitiseValue(noteName)
			console.log(safeValue)
			// Ensure no names are duplicated
			let noteNameNext = "" + noteName
			let x = 1
			while (nameIndex.hasOwnProperty(noteNameNext)) {
				noteNameNext = noteName + ` ${x}`
				x = x + 1
			}
			Progress.additionalDescription = `Inspecting ${noteName}…`

			myNotes.push({
				id: noteId,
				name: noteNameNext,
				aoNote: note,
				parent: item
				
			})
			nameIndex[noteNameNext] = true
		}
		item.notes = myNotes
	}, true);
}

