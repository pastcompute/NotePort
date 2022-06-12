use scripting additions

local folderAlias
local folderName

set folderAlias to ¬
	choose folder with prompt ¬
		"Choose an empty folder to backup your notes to:" default location (path to home folder)

-- set folderName to quoted form of POSIX path of folderAlias

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
			my processTheNotesFolder(theAccount, currentNoteFolder, theDestinationFolderPath)
			set n to n + 1
		end repeat
	end tell
end processTheNotesAccount

on processTheNotesFolder(theAccount, currentNoteFolder, theDestinationFolderPath)
	local outputPath
	set outputPath to my createFolderInPathIfMissing(theDestinationFolderPath, the name of currentNoteFolder)
	
	tell application "Notes"
		local noteCount
		local n
		set noteCount to the count of currentNoteFolder's notes
		set AppleScript's progress total steps to noteCount
		set AppleScript's progress completed steps to 0
		set AppleScript's progress description to "Enumerating notes"
		set n to 1
		repeat with currentNote in currentNoteFolder's notes
			local noteName
			set noteName to currentNote's name as text
			set AppleScript's progress additional description to noteName
			--log noteName
			my processTheNextNote(currentNote, missing value, missing value)
			set n to n + 1
			set notesProcessedCount to notesProcessedCount + 1
		end repeat
	end tell
end processTheNotesFolder

on processTheNextNote(theNote, theAccount, currentNoteFolder)
end processTheNextNote


