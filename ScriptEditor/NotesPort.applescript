use scripting additions

local folderAlias
local folderName

-- Note - current behaviour is, existing files in existing destination directory are left untouched
-- for best results, should prompt user to clear the destination

set folderAlias to ¬
	choose folder with prompt ¬
		"Choose an empty folder to backup your notes to:" default location (path to home folder)

global notesProcessedCount
set notesProcessedCount to 0

my processAllTheNotesAccounts(folderAlias)

return notesProcessedCount

on processAllTheNotesAccounts(topFolderAlias)
	tell application "Notes"
		local n
		local notesAccountCount
		local theNewFolderRef
		local notesAccountDiskFolder
		set n to 1
		set notesAccountCount to the count of its accounts
		set AppleScript's progress total steps to notesAccountCount
		set AppleScript's progress completed steps to 0
		set AppleScript's progress description to "Enumerating accounts"
		repeat with notesAccount in (its accounts)
			set notesAccountName to (the name of the notesAccount as text)
			set AppleScript's progress additional description to (notesAccountName)
			-- display alert notesAccountName
			-- log notesAccountName
			
			set theNewFolderPath to my createFolderInAliasIfMissing(topFolderAlias, notesAccountName)
			my processTheNotesAccount(notesAccount, theNewFolderPath)
			set AppleScript's progress completed steps to n
			set n to n + 1
		end repeat
	end tell
end processAllTheNotesAccounts

on createFolderInAliasIfMissing(topFolderAlias, newFolderToCreate)
	local theNewFolderPath
	set theNewFolderPath to (POSIX path of topFolderAlias) & "/" & newFolderToCreate
	do shell script "mkdir -p '" & theNewFolderPath & "'"
	return theNewFolderPath
end createFolderInAliasIfMissing

on createFolderInPathIfMissing(topFolderPath, newFolderToCreate)
	local theNewFolderPath
	set theNewFolderPath to topFolderPath & "/" & newFolderToCreate
	do shell script "mkdir -p '" & theNewFolderPath & "'"
	return theNewFolderPath
end createFolderInPathIfMissing

on processTheNotesAccount(theAccount, theDestinationFolderPath)
	tell application "Notes"
		local folderCount
		local n
		set folderCount to the count of theAccount's folders
		set AppleScript's progress total steps to folderCount
		set AppleScript's progress completed steps to 0
		set AppleScript's progress description to "Enumerating folders"
		set n to 1
		repeat with currentNoteFolder in theAccount's folders
			local folderName
			set folderName to currentNoteFolder's name as text
			set AppleScript's progress additional description to folderName
			--log folderName
			my processTheNotesFolder(theAccount, currentNoteFolder, folderName, theDestinationFolderPath)
			set n to n + 1
		end repeat
	end tell
end processTheNotesAccount

-- note, for performance we pass through already obtained fields
-- this can probably be restructred to move the progress to different place to avoid this...

on processTheNotesFolder(theAccount, currentNoteFolder, folderName, theDestinationFolderPath)
	local outputPath
	set outputPath to my createFolderInPathIfMissing(theDestinationFolderPath, folderName)
	
	tell application "Notes"
		local noteCount
		local n
		local numAttachments
		set noteCount to the count of currentNoteFolder's notes
		set AppleScript's progress total steps to noteCount
		set AppleScript's progress completed steps to 0
		set AppleScript's progress description to "Enumerating notes"
		set n to 1
		repeat with currentNote in currentNoteFolder's notes
			local noteName
			set noteName to currentNote's name as text
			set numAttachments to count of attachments of currentNote
			set AppleScript's progress additional description to noteName
			--log noteName
			my processTheNextNote(noteName, folderName, numAttachments, currentNote, theAccount, outputPath)
			set n to n + 1
			set notesProcessedCount to notesProcessedCount + 1
		end repeat
	end tell
end processTheNotesFolder

on processTheNextNote(noteName, folderName, numAttachments, theNote, theAccount, outputPath)
	local outputFile
	local escapedNoteName
	local tresc
	-- escape or replace slashes and quotes that might be in the note name, so we get a sane file
	set tresc to quoted form of "[\":/']"
	set escapedNoteName to (do shell script "echo " & (quoted form of noteName) & " | tr " & tresc & " _")
	set outputFile to POSIX file (outputPath & "/" & escapedNoteName & ".info.txt")
	set fp to open for access outputFile with write permission
	try
		write ("Folder=" & folderName & linefeed) to fp
		write ("Name=" & noteName & linefeed) to fp
		write ("AttachmentsCount=" & numAttachments & linefeed) to fp
		close access fp
	on error
		close access fp
	end try
	set outputFile to POSIX file (outputPath & "/" & escapedNoteName & ".html")
	tell application "Notes"
		local body
		set body to (the body of theNote)
		set fp to open for access outputFile with write permission
		try
			-- this can get sluggish, as it converts images to embedded JPEG data URLs
			write body to fp as text
			close access fp
		on error
			close access fp
		end try
	end tell
end processTheNextNote


