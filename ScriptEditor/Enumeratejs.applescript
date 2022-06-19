//const Safari = Application('Safari')
//const window = Safari.windows[0]
//const tab = window.currentTab
//const url = tab.url()
//console.log(url.get)


// https://www.galvanist.com/posts/2020-03-28-jxa_notes/
// https://brianlovin.com/hn/31579435
// https://gist.github.com/JMichaelTX/d29adaa18088572ce6d4

const currentApp = Application.currentApplication();
currentApp.includeStandardAdditions = true;

const outputFolder = currentApp.chooseFolder({withPrompt:"Choose a folder to save exported notes"})

//console.log(outputFolder.toString())

enumerateAccounts();

function enumerateAccounts() {
	const Notes = Application('Notes')
	const numAccounts = Notes.accounts.length
	for (let n=0; n < numAccounts; n++) {
		const account = Notes.accounts[n]
		console.log(account.name());
		enumerateFolders(account)
	}
}

// Strip out slashes and such and replace them with underscores
function sanitisePath(s) {
	return s
}

// Do something recursively down a tree in an array with children in each object
function recurseItems(tree, level, fn, descendFirst) {
	for (const item of tree) {
		hasChildren = item.hasOwnProperty('children')
		if (descendFirst && hasChildren) {
			recurseItems(item.children, level+1, fn, descendFirst)
		}
		fn(item, level)
		if (!descendFirst && hasChildren) {
			recurseItems(item.children, level+1, fn, descendFirst)
		}
	}
}

// https://medium.com/@lizhuohang.selina/building-a-hierarchical-tree-from-a-flat-list-an-easy-to-understand-solution-visualisation-19cb24bdfa33
// Build up a tree of linking objects...
// Two stages for simplicty - hashmap the folders first
function enumerateFolders(account) {
	const accountId = account.id()
	const myFolders = {}
	const numFolders = account.folders.length
	for (let n=0; n < numFolders; n++) {
		const folder = account.folders[n]
		const folderId = folder.id()
		const folderName = folder.name()
		const parent = folder.container
		const parentId = parent.id()
		//console.log(folder.name() + '; ' + folder.id());
		//console.log(parent.id());
		if (!myFolders.hasOwnProperty(folderId)) {
			myFolders[folderId] = {
				id: folderId,
				folder: folder,
				name: folderName,
				parentId: parentId,
				children: []
			}
		} else {
			throw "Should not happen"
		}
	}
	//console.log(JSON.stringify(myFolders, null), "  ")

	// Now enumerate the hash map and move objects to the right place
	// Strip out the root parent ids now
	// This gives us a tree to clone on disk
	const folderIds = Object.getOwnPropertyNames(myFolders)
	const tree = []
	for (const k of folderIds) {
		if (myFolders.hasOwnProperty(k)) {
			const m = myFolders[k]
			const parentId = m.parentId
			// We could strip the parentId entirely, to save space...
			if (parentId === accountId) {
				// root
				m.parentId = null
				m.parent = null
				tree.push(m)
			} else {
				m.parent = myFolders[parentId]
				myFolders[parentId].children.push(m)
			}
		}
	}
	
	const pathPrefix = outputFolder.toString() + '/' + sanitisePath(account.name())
	
	// We could probably merge this with the above, but go back through and
	// and clean folder path names for saving to disk
	recurseItems(tree, 0, (item, level) => {
		// console.log(`RecurseFunction: ${level} --> ${item.name}`)
		if (level > 0) {
			// for this to work we need to descend after, so the parents path is set
			item['path'] = item.parent.path + '/' + sanitisePath(item.name)
		} else {
			item['path'] = pathPrefix + '/' + sanitisePath(item.name)
		}
	}, false);
	// console.log(JSON.stringify(tree, ['name', 'path', 'children'], "  "))
	
	// Now visit each folder and get its notes
	const Notes = Application('Notes')
	recurseItems(tree, 0, (item, level) => {
		const myNotes = []
		const theNotes = item.folder.notes
		const numNotes = theNotes.length
		for (let n=0; n < numNotes; n++) {
			const note = theNotes[n]
			const noteId = note.id()
			const noteName = note.name()
			myNotes.push({
				id: noteId,
				name: noteName
			})
		}
		item.notes = myNotes
		// console.log(JSON.stringify(myNotes, null, "  "))
	}, true);
	
	// console.log(JSON.stringify(tree, null, "  ")) // recursive error?
	recurseItems(tree, 0, (item, level) => {
		console.log(JSON.stringify(item.notes, null, "  "))
	}, true)
}

