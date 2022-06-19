use scripting additions
use framework "Foundation"

global theLogFile
set theLogFile to (POSIX path of (path to home folder)) & "/notes-enumeration.txt"

do shell script "echo '--- Notes ---' > " & quoted form of theLogFile

my enumerateAccounts(missing value)

on enumerateAccounts(enumerateOnlyOneAccountName)
	tell application "Notes"
		local n
		local accountCount
		local skipAccount
		set n to 1
		set accountCount to the count of its accounts
		set AppleScript's progress total steps to accountCount
		set AppleScript's progress completed steps to 0
		set AppleScript's progress description to "Enumerating accounts..."
		repeat with theAccount in (its accounts)
			set theAccountName to (the name of the theAccount as text)
			set AppleScript's progress additional description to (theAccountName)
			set skipAccount to false
			if enumerateOnlyOneAccountName is not missing value then
				set skipAccount to true
				if theAccountName = enumerateOnlyOneAccountName then -- ≠
					set skipAccount to false
				end if
			end if
			if skipAccount is false then
				my enumerateAccount(theAccount)
			end if
			set AppleScript's progress completed steps to n
			set n to n + 1
		end repeat
	end tell
end enumerateAccounts

on enumerateAccount(theAccount)
	do shell script "echo 'Account: " & (theAccount's name as text) & "' >> " & quoted form of theLogFile
	tell application "Notes"
		local folderCount
		set folderCount to the count of theAccount's folders
		set AppleScript's progress total steps to folderCount
		set AppleScript's progress completed steps to 0
		set AppleScript's progress description to "Enumerating folders"
		my enumerateFolders(theAccount, (theAccount's name as text), 0)
	end tell
end enumerateAccount

-- recursively enumerate folders, outputting just the ones at this level
-- because of the way applescript works, this will get expensive (repetitive processing) if there are a large number of folders
-- because at each recursion level, we need to look at all of them. Thus, it is O(kN) for k levels and N total folders
on enumerateFolders(theAccount, theParentFolderName, level)
	tell application "Notes"
		local n
		set n to 1
		repeat with theNoteFolder in theAccount's folders
			local folderName
			local theContainer
			set folderName to theNoteFolder's name as text
			set theContainer to theNoteFolder's container
			if the level is 0 then
				if (the class of theContainer) is account then
					do shell script "echo '  Folder:  " & folderName & " (Parent is account)' >> " & quoted form of theLogFile
					set AppleScript's progress additional description to folderName
					my enumerateFolders(theAccount, folderName, level + 1)
				else
					-- this has a parent of something else, ignore for now
				end if
			else
				if (the class of theContainer) is folder then
					do shell script "echo '  Folder:  " & folderName & " Parent: " & (the name of theContainer) & "' >> " & quoted form of theLogFile
					set AppleScript's progress additional description to folderName
				end if
			end if
			set n to n + 1
		end repeat
	end tell
end enumerateFolders
