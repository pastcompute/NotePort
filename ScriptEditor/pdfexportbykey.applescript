(function(){
'use strict'
ObjC.import('Foundation')
const currentApp = Application.currentApplication();
currentApp.includeStandardAdditions = true;
const desktopFolder = `${currentApp("desktop")}`;
const documentsFolder = currentApp.pathTo("documents folder", {from: "user domain", as: "alias"}).toString()
console.log(documentsFolder)
const Notes = Application('Notes')

const selection = Notes.selection()
const ns = selection.length
console.log(`Selected note count ${ns}`)

const note = selection[0]

// Borrowed from https://forum.keyboardmaestro.com/t/why-do-we-code-jxa-scripts-using-closures/4739
const FileUtils = (function() {
    return {
        fileExists: function(path) {
            const result = this.getFileOrFolderExists(path);
            return result.exists && result.isFile;
        },

        getFileOrFolderExists: function(path) {
			console.log(`Check exists: ${path}`)
            const isDirectory = Ref();
            const exists = $.NSFileManager.defaultManager.fileExistsAtPathIsDirectory(path, isDirectory);
			console.log(`Check exists: ${path} --> ${exists}`)
            return {
                exists: exists,
                isFile: isDirectory[0] !== 1
            };
        }
    };
})();

//console.log(Notes.application.version)
// Notes.quit()

//Notes.print(note)
//note.print()
//Notes.print(note())

const seApp = Application("System Events")
Notes.activate()
delay(0.6)
const oProcess = seApp.processes.whose({frontmost: true})[0]
console.log(oProcess.displayedName())

const fileMenu = oProcess.menuBars[0].menuBarItems.byName('File')
//const exportMenu = fileMenu.menus[0].menuItems.byName('Close')
//const exportMenu = fileMenu.menus[0].menuItems.byName('Export as PDF')
//const m = fileMenu.menus[0].menuItems
//for (let n = 0; n < m.length; n++) {
// console.log(m[n].name())
 // FFS they dont all have a name, and some show as nested FUCK
 // Indeed it doesnt even match the fucking menu
 // it seems we need a delay or it gets Safaris or Script Editors
//}

//ookay, magic three dots
const exportMenu = fileMenu.menus[0].menuItems.byName('Export as PDF…')
exportMenu.click()

const CANARY = '[None][None][None][None][None][None]'

function copyClipboard(setterFunction=null) {
	currentApp.setTheClipboardTo(CANARY)
	delay(0.1)
	if (!setterFunction) {
		seApp.keystroke('a', {using: 'command down'})
		delay(0.1)
		// Copy to clipboard
		seApp.keystroke('c', {using: 'command down'})
		delay(0.1)
	} else if (!setterFunction()) { return }	
	const delay_s = 0.2
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


// Now, how do we click on the dialog that popped up? Send ENTER
// These delays are finnicky
delay(0.6)
// https://jxa-examples.akjems.com
// https://forum.keyboardmaestro.com/t/how-to-use-jxa-with-system-events-app/6341/3
// https://eastmanreference.com/complete-list-of-applescript-key-codes
// 1. It starts with the cursor in the filename, so lets press Command+A to grab it all

//seApp.keyDown('eCmd'); // this actually types. WTF
//seApp.keyDown(56); // command
//seApp.keystroke('a')
//seApp.keyUp(56);

const clipContents = copyClipboard()
if (!clipContents) throw "bad clipboard"

//console.log(oProcess.properties())
// https://support.apple.com/en-au/HT201236
// What about the path?
// Shift + Command + G will let us type a path

const destDir = documentsFolder + '/_demodir'
currentApp.doShellScript(`mkdir -p '${destDir}'`)
let good = false
try {
	seApp.keyDown(55); // command
	seApp.keyDown(56); // shift
	seApp.keyDown(5) // g
	good = true
} catch (e) {
}
seApp.keyUp(5)
seApp.keyUp(55);
seApp.keyUp(56);
if (good) {
	delay(0.2)
 	// this is too fast due to autocomplete --> seApp.keystroke(`${destDir}`)
	// for (let c of destDir) { seApp.keystroke(c) ; delay(0.01) ; }

	// PASTE
	currentApp.setTheClipboardTo(destDir)
	delay(0.2)
	seApp.keystroke('v', {using: 'command down'})
	delay(0.1)


	// ENTER
	seApp.keyDown(36) 
	seApp.keyUp(36) 
	delay(0.02)

}

function getExt(fileName) {
	if (!fileName) return null
	const r = fileName.split('.')
	if (r.length < 2) return ""
	return r.reverse()[0]	
}

// FIXME TODO check for bogus characters
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
console.log(`${filePathTry}; ${fb}; ${ext}`)
while (FileUtils.fileExists(filePathTry)) {
	console.log("try copy " + fn)
	paster = `${fb} (Copy ${fn})${ext}`
	filePathTry = Path(`${destDir}/${paster}`).toString()
	fn = fn + 1
	console.log("try copy " + filePathTry)
}
console.log("try and " + filePathTry)
// Paste it back in now
if (paster) {
	delay(0.1)
	seApp.keystroke('a', {using: 'command down'})
	delay(0.1)
	for (let c of paster) {
		seApp.keystroke(c)
		delay(0.01)
	}
}
// ENTER

delay(0.05)
seApp.keyDown(36) 
seApp.keyUp(36) 
delay(0.02)


//currentApp.displayDialog(`${filePathTry}`, {buttons: ["Continue"]})

// Fuck why does the dialog come up already
// delay(0.2); currentApp.displayDialog(`${clipContents}`, {buttons: ["Continue"]})

// https://stackoverflow.com/questions/32021870/sending-system-events-key-down-up-using-jxa
//seApp.keystroke('\n')
if (false) {
seApp.keyDown(36) 
seApp.keyUp(36) 
}
// Fuck it doesnt to tabbing like Windows/. Fuck me. ESC works though...
//delay(0.1) // in case of replace?
//seApp.keyDown(36) 
//seApp.keyUp(36) 

// In theory we can get real funky now though. Detect the name it will save as, then see if it exists, and if so, add a (1), all using the keyboard

console.log('tada')

// Glitch - test beforehand if file exists?

})()
