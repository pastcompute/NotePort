(function(){
'use strict'
ObjC.import('Foundation')
const currentApp = Application.currentApplication()
currentApp.includeStandardAdditions = true
const Notes = Application('Notes')
const selectionRef = Notes.selection()
const ns = selectionRef.length
console.log(`Selected note count: ${ns}. Processing only the first.`)

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

const noteRef = selectionRef[0]
const noteData = {
	noteRef: noteRef,
	id: noteRef.id(),
	name: noteRef.name(),
	created: noteRef.creationDate(),
	modified: noteRef.modificationDate(),
	parents: [getContainerInfo(noteRef.container())],
}

// Recursively find all components in the Notes folder hierarchy
// For efficiency, we try and make a cache of results from functions that
// end up calling apple script events (the `containers` field)

let n = 1
for (; n < MAX_FOLDER_DEPTH; n++) {
	console.log(n)
	let container = getContainerInfo(noteData.parents[n-1].parentRef)
	noteData.parents.push(container)
	if (!container.parentRef) { break }
}
if (n > MAX_FOLDER_DEPTH) {
	throw `We cant handle a folder nest of ${MAX_FOLDER_DEPTH} layers deep!`
}

console.log(JSON.stringify(noteData, replacer, 2))
})()

// code: language=JXA insertSpaces=false tabSize=4
