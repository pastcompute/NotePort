(function(){
'use strict'
ObjC.import('Foundation')
let currentApp = Application.currentApplication()
currentApp.includeStandardAdditions = true
const Notes = Application('Notes')
const SystemEvents = Application("System Events")

Notes.activate()
//currentApp = Application.currentApplication()

const process = SystemEvents.processes.whose({frontmost: true})[0]

const CANARY = '[None][None][None][None][None][None]'

function copyClipboard(setterFunction=null) {
	currentApp.setTheClipboardTo(CANARY)
	delay(0.1)
	if (!setterFunction) {
		SystemEvents.keystroke('a', {using: 'command down'})
		delay(2)
		// Copy to clipboard - except CMND+C doesnt always work WTAF
		// How can we trigger right click - copy ?
		SystemEvents.keystroke('c', {using: 'command down'})
		delay(0.1)
	} else if (!setterFunction()) { return }	
	const delay_s = 0.1
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

// Do export menu first...
// 

console.log(process.name())
process.click()
SystemEvents.keyDown(124)

// Massive list, with windows("Notes"), menu bars, etc
// where every bloody note has some stuff
//console.log(JSON.stringify(process.entireContents(), null, 2))

// console.log(JSON.stringify(process.windows[0].entireContents(), null, 2))

// one window - "Notes"
// Maybe :?
//app.applicationProcesses.byName("Notes").windows.byName("Notes").sheets.at(0).sheets.at(0).scrollAreas.at(0).tables.at(0).rows.at(0).uiElements.byName("Go to:").staticTexts.byName("Go to:")
// app.applicationProcesses.byName("Notes").windows.byName("Notes").sheets.at(0).sheets.at(0).scrollAreas.at(0).tables.at(0).rows.at(0).uiElements.byName("Go to:")
// console.log(JSON.stringify(process.windows(), null, 2))


//const elements = process.uiElements.windows
//for (let v=0; v < elements; v++) {
//	console.log(elements[v].name())
//}


// const c = copyClipboard() ; console.log(c)
})()

// code: language=JXA insertSpaces=false tabSize=4
