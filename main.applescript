--  New File.app
--  Created by Ryan Domingue 2/13; Updated 3/30/2013

global this_folder
global filename
property defaultFilename : "new"
property promptForNewFilenameOnOverwrite : true

--------------------------------------------------------------
--  Receives message and defalt answer for prompt window

--  Prompts for user-entered text
--  Returns a the given text
--------------------------------------------------------------
on requestText(cmt, rtn)
	
	set myButtons to {"Cancel", "Okay"}
	set myDefaultButton to 2
	
	--> request text
	try
		--> display the comments and ask for edits/additions
		set request to display dialog cmt default answer rtn buttons myButtons Â
			default button myDefaultButton with icon note with title "Create new file"
	on error msg number e
		if e is -128 then --> user cancelled
			return
		end if
	end try
	
	-- global filename variable set to user-entered text
	set filename to (text returned of request)
	
end requestText

--------------------------------------------------------------
--  Receives a filename (string)

--  Split the string at the "."
--------------------------------------------------------------
on disectFilename(filename)
	
	set oldDelims to AppleScript's text item delimiters
	set AppleScript's text item delimiters to "."
	set filenameSplit to every text item of filename
	return filenameSplit
	
end disectFilename

--------------------------------------------------------------
--  Increment the filename for existing files	
--------------------------------------------------------------
on incrementFilename()
	
	tell application "Finder"
		set i to 0
		set fileExists to true
		set splitToIncrement to my disectFilename(filename)
		-- cycle through and increment the filename
		repeat while fileExists is true
			if exists file (this_folder & filename) then
				set i to i + 1
				set filename to (the first item of splitToIncrement & Â
					" (" & i & ")." & the second item of splitToIncrement)
			else
				set fileExists to false
			end if
		end repeat
	end tell
	
end incrementFilename

--------------------------------------------------------------
--  Prompt for new filename for existing files	
--------------------------------------------------------------
on promptForNewName()
	
	tell application "Finder"
		set fileExists to true
		repeat while fileExists is true
			if exists file (this_folder & filename) then
				-- set up prompt and prompt user for filename/extention
				set cmt to "A file by that name already exists" & return & return & "Please enter a new filename."
				set rtn to filename as text
				my requestText(cmt, rtn)
			else
				set fileExists to false
			end if
		end repeat
	end tell
	
end promptForNewName

--------------------------------------------------------------
--  Create the damn thing already	
--------------------------------------------------------------
on createFile()
	
	set the_path to POSIX path of this_folder
	
	repeat until the_path ends with "/"
		set the_path to text 1 thru -2 of the_path
	end repeat
	
	set cmd to "touch " & "\"" & the_path & filename & "\""
	
	do shell script cmd
	
end createFile

--------------------------------------------------------------
--  The icon is clicked
--------------------------------------------------------------
on run
	
	set filename to ""
	
	-- set up prompt and prompt user for filename/extention
	set cmt to "Enter:" & return & return & "1) A file extension" & return & "2) A filename with an extension"
	set rtn to ""
	my requestText(cmt, rtn)
	
	if filename is "" then return
	
	-- get the folder path of front window or esktop if no window is open
	tell application "Finder"
		activate
		
		try
			set this_folder to (the target of the front window) as text
		on error
			set this_folder to desktop as text
		end try
		
	end tell
	
	-- divide the string to tell whether or not there was a filename.extention entered
	set splitString to my disectFilename(filename)
	
	-- if only a file extention was entered, the filename will be "new"
	if (count of splitString) is less than 2 then
		set filename to (defaultFilename & "." & the first item of splitString)
	end if
	
	-- check of the file exists
	try
		if promptForNewFilenameOnOverwrite then
			-- prompt for a new filename when file already exisis
			my promptForNewName()
			
		else
			-- increment filenames for previously existing files
			my incrementFilename()
		end if
		
	on error
		display dialog "Generic, unhelpful error message." & return & return & "Sorry about that."
	end try
	
	-- create the file
	my createFile()
	
end run
