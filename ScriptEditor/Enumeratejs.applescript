// Helpful references:
// https://www.galvanist.com/posts/2020-03-28-jxa_notes/
// https://brianlovin.com/hn/31579435
// https://gist.github.com/JMichaelTX/d29adaa18088572ce6d4

const currentApp = Application.currentApplication();
currentApp.includeStandardAdditions = true;

const globals = { }

try {
	start()
} finally {
	delete currentApp
}

function start() {
	globals.outputFolder = currentApp.chooseFolder({withPrompt:"Choose a folder to save exported notes to"})
	enumerateAccounts();
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
	const Notes = Application('Notes')
	const numAccounts = Notes.accounts.length
	for (let n=0; n < numAccounts; n++) {
		const account = Notes.accounts[n]
		const accountName = account.name()
		console.log(`Account: ${accountName}`);
		if (accountName === 'iCloud') continue

		const tree = enumerateFolders(account)
		enumerateNotes(tree)
		// console.log(JSON.stringify(tree, replacer, "  "))
		
		recurseItems(tree, 0, (item, level) => {
			// console.log(JSON.stringify(item.notes, replacer, "  "))
			
			// Create destination folder if missing
			currentApp.doShellScript(`mkdir -p '${item.path}'`)

			// Save the notes, in various forms
			//console.log(JSON.stringify(item.notes, replacer, "  "))
			for (const note of item.notes) {
				//console.log(JSON.stringify(note, replacer, "  "))
				const safeName = sanitisePath(note.name)
				const safeValue = sanitiseValue(note.name)
				const metaFile = item.path  + '/' + safeName + '.txt'
				currentApp.doShellScript(`echo 'id=${note.id}' > '${metaFile}'`)
				currentApp.doShellScript(`echo 'parent=${note.parent.id}' >> '${metaFile}'`)
				currentApp.doShellScript(`echo 'name=${safeValue}' >> '${metaFile}'`)
			}
		}, true)
	}
}

// Helper function to escape things that will go in shell single quote strings, that are not filenames
function sanitiseValue(s) {
	const result = s
		.replace("'", "'\"'\"'", "g")

	return result // remember, return dot lines cant break...
}

// Helper function to strip out slashes and such and replace them with underscores, etc.
function sanitisePath(s) {
	//console.log(`sanitisePath s=${s}`)
	const result = s
		.replace("'", "_", "g")
		.replace("\"", "_", "g")
		.replace("\\", "_", "g")
		.replace("/", "_", "g")

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
function enumerateNotes(tree) {	
	const Notes = Application('Notes')
	recurseItems(tree, 0, (item, level) => {
		const myNotes = []
		const theNotes = item.aoFolder.notes
		const numNotes = theNotes.length
		for (let n=0; n < numNotes; n++) {
			const note = theNotes[n]
			const noteId = note.id()
			const noteName = note.name()
			myNotes.push({
				id: noteId,
				name: noteName,
				aoNote: note,
				parent: item
			})
		}
		item.notes = myNotes
	}, true);
}

