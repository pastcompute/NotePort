# Notesport - Apple Notes PDF exporter

This program will actually, properly, in a WYSIWYG manner, export every note in your Notes app to PDF, while preserving (inasmuch there are special characters that might need adjusting) the folder hierarchy and notes titles, and dealing with avoiding duplicate filenames.

Unfortunately, it works by sending keyboard events to notes, because I have not succesfully managed to get the AOSC API to properly export attachments in all cases - in my own case, about 1 in 4 pictures or other attachments just wont export (usually, it seems to be somehow related to iCloud), at all. Indeed, in this incarnation, some things are still probably lost (e.g. if you attached a PDF inside a note; also, images in 'small' format will end up in the PDF, as, well, small in size.) But at a minimum, all notes including text, formatting Apple Pencil markup and images, will end up in PDF as you would see them in notes. Which makes it a useful backup when you primarly use notes as a journal or dumping ground. 

One day Apple will give notes a proper API like the Calendar and other things do.

# Usage

- Open the Apple ScriptEditor on your Mac
- Create a new script, change the type to Javascript
- Copy and paste the content of ScriptEditor/ExportAllTheNotesToPdf.applescript into it (you really should not trust scpt files...)
- Ensure that Notes app has no open Windows or save dialogs, etc.
- Run the Script, choose a destination folder, wait.

For best results, choose a new empty folder!

# WARNING

Due to the way this sends keys and interacts with the clipboard, once the process starts, avoid using the computer to do anything else!

It can be aborted by hitting the Stop button in the Scripting App.

# Repository contents

The only script you need is `ScriptEditor/ExportAllTheNotesToPdf.scpt`, all the others are experiments where I was trying to find a way to use the Notes applescript API to get the underlying content and enumerate all the original attachments, and save the result in HTML as I was originally hoping to convert it to Markdown and at the same time preserve attachments in separate files. However, a good chunk of my notes just failed.