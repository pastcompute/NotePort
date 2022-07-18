(function(){
'use strict'
const currentApp = Application.currentApplication();
currentApp.includeStandardAdditions = true;
const desktopFolder = `${currentApp("desktop")}`;
const documentsFolder = currentApp.pathTo("documents folder", {from: "user domain", as: "alias"}).toString()
console.log(documentsFolder)
const Notes = Application('Notes')

// IMPORTANT: This is JXA, not AppleScript, so change the type in the ScriptEditor window (upper left)

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

function getExt(fileName) {
	if (!fileName) return null
	const r = fileName.split('.')
	if (r.length < 2) return ""
	return r.reverse()[0]	
}

function getSuff(fileName) {
	if (!fileName) return null
	const r = fileName.split('/')
	if (r.length < 2) return ""
	return r.reverse()[0]	
}


// Notably, some exports dont have their item as an attachment...
// Solution must only be, to de-embed the embedded HTML data URL
// Some of these are direct camera captures

if (numAttachments > 0) {
	console.log('AttachmentId=' + attachments[0].id())
	for (let n = 0; n < numAttachments; n++) {
		const att = attachments[n]
		const props = att.properties()
		console.log('props')
		console.log(props)
		// pcls == 'attachment'
		// creationDate, modificationDate, shared, contents == null, name, url == null
		// id == 'x-coredata://181F2744-C17D-41B1-B66D-AA72560FF0A2/ICAttachment/p821'
		// contentIdentifier == 'cid:12FB1CFC-57AE-45AA-A401-778C457EEF77@icloud.apple.com'
		// container == app.notes.byId("x-coredata://181F2744-C17D-41B1-B66D-AA72560FF0A2/ICNote/p818")
		
		let attachmentExtension = getExt(props.name)
		if (!attachmentExtension) {
			attachmentExtension = 'pdf'
		}
		const attachmentFilename = getSuff(props.id) + '.' + attachmentExtension
		const attachmentPathname = `${documentsFolder}/${attachmentFilename}`
		try {
			//Notes.save(att, {in: Path(attachmentPathname)}) // Note, this works for working attachments
			// Working attachments:
			// - contents != null, is instead a Path()
			// - name, has an extension such as .png
			
			
			//Notes.save(att, {in: Path(attachmentPathname), as: 'native format'})
			//Notes.save(att, {in: Path(attachmentPathname), as: 'pdf'})
			//Notes.save(att, {in: Path(attachmentPathname), as: 'png'})
			//Notes.save(att, {in: Path(attachmentPathname), as: 'JPEG'})
			// as pdf --> -1700 cant convert types (this is a step forward, vs -10000 AppleEvent handler failed. png is also cant convert types
			// using att() or att doesnt matter
			
			//Notes.show(att, {separately: true})
			// Make this work for working atts:
			//Notes.delete(att) // works ...
			//Notes.duplicate(att, {to: Path(attachmentPathname)}) //nope - 1700 cant convert - for ALL 
			// Notes.duplicate(att) // -1717 handler is not defined
			//Notes.duplicate(att, {to: Path(documentsFolder)}) //not a dir - 1700 cant convert - for ALL 
			//att.duplicate({to: Path(documentsFolder)})
			//att.save({in: Path(attachmentPathname)}) // alt for working ones; -10000 for fails
			//att.save({in: Path(documentsFolder)}) // alt for working ones; -10000 for fails
			att.save({in: attachmentPathname}) // alt for working ones; -10000 for fails
			// Notes.show(att) // works
		} catch (e) {
			console.log('oops')
			console.log(e)
			console.log(e.message)
		}
	}
	// Attachments that work, has a 'contents' property which is a Path()
	// Some have an iCloud ID, is this the common factor in the errors?
	
	// Duplicating and moving a note to 'On My Mac' still fails in same way
	// Note, where the attach should go is always `<div><br><br></div>`
	
	// Turns out after exporting the file is actually in /private/var/folders/k3/3mjy7nb50zqcwq0s4pwdp8sc0000gn/T/com.apple.Notes/galleryTempPDFFolder/12FB1CFC-57AE-45AA-A401-778C457EEF77/1656238995/The First 2 Hours.pdf
	// Same location is in clipboard... but only after we copy it
	
}

// It looks like the errors are always iCloud, and have no file extension in the name
// It is not all iCloud cid though, only some...
// Typically will either be apple pencil diagrams, or something else
// Yet same thing can be dragged to finder on Mac and becomes a PNG
// These will then generally be an embedded data url as well
// Note, tables are also attachments for this purpose... which also go into the HTML

//debugger



})()

//    var sys = Application("System Events");
//    var user_name = sys.currentUser().name();

// code: language=JXA insertSpaces=false tabSize=4
