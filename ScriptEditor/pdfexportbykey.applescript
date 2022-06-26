(function(){
'use strict'
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

//console.log(Notes.application.version)
// Notes.quit()

//Notes.print(note)
//note.print()
//Notes.print(note())

const seApp = Application("System Events")
Notes.activate()
delay(0.1)
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

// Now, how do we click on the dialog that popped up? Send ENTER
delay(1.2)
// https://stackoverflow.com/questions/32021870/sending-system-events-key-down-up-using-jxa
//seApp.keystroke('\n')
seApp.keyDown(36) 
seApp.keyUp(36) 

// Fuck it doesnt to tabbing like WIndows/. Fuck me. ESC works though...
//delay(0.1) // in case of replace?
//seApp.keyDown(36) 
//seApp.keyUp(36) 

// In theory we can get real funky now though. Detect the name it will save as, then see if it exists, and if so, add a (1), all using the keyboard

console.log('tada')

// Glitch - test beforehand if file exists?

})()
