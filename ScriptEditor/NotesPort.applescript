use scripting additions
use framework "Foundation"

local folderAlias
local folderName

-- Note - current behaviour is, existing files in existing destination directory are left untouched
-- for best results, should prompt user to clear the destination
-- note - it is not clear if this will produce consistent output
-- if a user renames or edits something while an export is in progress, because of the multiple `tell X` stages

-- TODO - allow just one account to be selected
-- TODO - allow just one or a subset of folders to be selected

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
			
			if notesAccountName = "On My Mac" then
				set theNewFolderPath to my createFolderInAliasIfMissing(topFolderAlias, notesAccountName)
				my processTheNotesAccount(notesAccount, theNewFolderPath)
			end if
			set AppleScript's progress completed steps to n
			set n to n + 1
		end repeat
	end tell
end processAllTheNotesAccounts

on createFolderInAliasIfMissing(topFolderAlias, newFolderToCreate)
	local theNewFolderPath
	set theNewFolderPath to (POSIX path of topFolderAlias) & newFolderToCreate
	do shell script "mkdir -p " & quoted form of theNewFolderPath
	return theNewFolderPath
end createFolderInAliasIfMissing

on createFolderInPathIfMissing(topFolderPath, newFolderToCreate)
	local theNewFolderPath
	set theNewFolderPath to topFolderPath & "/" & newFolderToCreate
	do shell script "mkdir -p " & quoted form of theNewFolderPath
	return theNewFolderPath
end createFolderInPathIfMissing

on sanitiseFilename(theFilename)
	-- escape or replace slashes and quotes that might be in the note name, so we get a sane file
	local tresc
	local sanitisedName
	set tresc to quoted form of "[\":/']"
	set sanitisedName to (do shell script "echo " & (quoted form of theFilename) & " | tr " & tresc & " _")
	return sanitisedName
end sanitiseFilename

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
			my processTheNextNote(noteName, folderName, currentNote, theAccount, outputPath)
			set n to n + 1
			set notesProcessedCount to notesProcessedCount + 1
		end repeat
	end tell
end processTheNotesFolder

on processTheNextNote(noteName, folderName, theNote, theAccount, outputPath)
	local outputFile
	local escapedNoteName
	local theAttachments
	local numAttachments
	local attachmentName
	local escdAttachmentName
	local attachmentId
	local theURL
	local theBasename
	local n
	local attachPath
	local attachFile
	
	-- escape or replace slashes and quotes that might be in the note name, so we get a sane file
	set escapedNoteName to my sanitiseFilename(noteName)
	set outputFile to POSIX file (outputPath & "/" & escapedNoteName & ".info.txt")
	tell application "Notes"
		set numAttachments to the count of theNote's attachments
		set theAttachments to theNote's attachments
	end tell
	-- for performance save the attachments as we are enumerating them
	set fp to open for access outputFile with write permission
	try
		write ("Folder=" & folderName & linefeed) to fp
		write ("Name=" & noteName & linefeed) to fp
		write ("AttachmentsCount=" & numAttachments & linefeed) to fp
		set n to 0
		repeat with currentAttachment in theAttachments
			set attachmentName to the name of currentAttachment
			set attachmentId to the id of currentAttachment
			set theURL to (current application's NSURL's URLWithString:attachmentId)
			set theBasename to theURL's lastPathComponent as text
			set escdAttachmentName to my sanitiseFilename(attachmentName)
			set attachPath to (escapedNoteName & "_" & theBasename & "_" & escdAttachmentName)
			log attachPath
			set attachFile to POSIX file (outputPath & "/" & attachPath)
			write ("Attachment." & n & ".name=" & attachmentName & linefeed) to fp
			write ("Attachment." & n & ".id=" & attachmentId & linefeed) to fp
			write ("Attachment." & n & ".bn=" & theBasename & linefeed) to fp
			write ("Attachment." & n & ".path=" & attachPath & linefeed) to fp
			-- write the non-data URL for the moment?
			-- note images can also be HEIC, so in due course we need to convert them to something renderable off of safari!
			if text -4 through -1 of attachPath ≠ ".png" then
				if text -5 through -1 of attachPath ≠ ".jpeg" then
					save currentAttachment in file (attachFile as string)
				end if
			end if
			set n to n + 1
		end repeat
		close access fp
	on error
		close access fp
	end try
	-- generate the actual core export
	set outputFile to POSIX file (outputPath & "/" & escapedNoteName & ".html")
	set fp to open for access outputFile with write permission
	try
		-- this can get sluggish, as it converts images to embedded JPEG and PNG data URLs
		tell application "Notes"
			local body
			set body to (the body of theNote)
			write body to fp as text
		end tell
		close access fp
	on error
		close access fp
	end try
	#	-- enumerate attachments, and save them out as well
	#	-- ideally, we'd skip anything that is already a data URL though...
	#	repeat with currentAttachment in theAttachments
	#		set attachmentName to the name of currentAttachment
	#		repeat with currentAttachment in theAttachments
	#			set attachmentName to the name of currentAttachment
	#			set attachmentId to the id of currentAttachment
	#			set theURL to (current application's NSURL's URLWithString:attachmentId)
	#			set theBasename to theURL's lastPathComponent as text
	#			set escdAttachmentName to (do shell script "echo " & (quoted form of attachmentName) & " | tr " & tresc & " _")
	#			set attachPath to (outputPath & "/" & escapedNoteName & "_" & theBasename & "_" & escdAttachmentName)
	#			log attachPath
	#			set attachFile to POSIX file attachPath
	#			# save theAttachment in attachFile
	#		end repeat
	#	end repeat
end processTheNextNote


