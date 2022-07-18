// Clipboard test

(function(){
'use strict'
const currentApp = Application.currentApplication();
currentApp.includeStandardAdditions = true;


const clipContents = currentApp.theClipboard()


})()

// 	app.theClipboard()
//	--> {"furl":Path("/private/var/folders/k3/3mjy7nb50zqcwq0s4pwdp8sc0000gn/T/com.apple.Notes/galleryTempPDFFolder/12FB1CFC-57AE-45AA-A401-778C457EEF77/1656238995/The First 2 Hours.pdf")}
		
// So, we can drag and drop this, but not paste, into Pages ...

// After I copy a dragged item from Pages, it is a PDF
// In fact, I can drag it to Finder and it becomes a PDF...
// code: language=JXA insertSpaces=false tabSize=4
