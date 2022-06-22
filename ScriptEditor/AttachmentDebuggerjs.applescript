(function(){
'usr strict'
const currentApp = Application.currentApplication();
currentApp.includeStandardAdditions = true;
const desktopFolder = `${currentApp("desktop")}`;
const Notes = Application('Notes')

const selection = Notes.selection()
const ns = selection.length

//currentApp.displayDialog(`Selected note count ${ns}`, {buttons: ["Continue"]})

// Just process first for now
const note = selection[0]
console.log('Properties=' + note.properties()) // <-- "[object Object], but we see it all in the log history
// --> dumps a lot of stuff into the log history, usful to check spelling
// --> we can see all the things we usually get e.g.
// --> container (app obj), pcls == "note", passwordProtected, modificationDate, creationDate, shared
// --> body (as HTML, with data URL)
// --> notably, the one we cant export is 'data:image/png;base64,...'
// --> id, name, plaintext

const attachments = note.attachments // can either have () or not and still works!
const numAttachments = attachments.length
console.log('Note.id=' + note.id())
console.log('numAttachments=' + numAttachments)

// Notably, some exports dont have their item as an attachment...
// Solution must only be, to de-embed the embedded HTML data URL
// Some of these are direct camera captures

if (numAttachments > 0) {
	console.log('AttachmentId=' + attachments[0].id())
	console.log(attachments[0].properties())
	// Attachments that work, has a 'contents' property which is a Path()
	// Some have an iCloud ID, is this the common factor in the errors?
}

// It looks like the errors are always iCloud, and have no file extension in the name
// It is not all iCloud cid though, only some...
// Typically will either be apple pencil diagrams, or something else
// Yet same thing can be dragged to finder on Mac and becomes a PNG
// These will then generally be an embedded data url as well
// Note, tables are also attachments for this purpose... which also go into the HTML

//debugger



})()
