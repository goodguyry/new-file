New File
========

An AppleScript application (with a ridiculously unimaginative name) for quickly adding a new file.

New File will add a new file to the open Finder window or the desktop (if Finder is not open). Best run from the Finder toolbar. When run, you are prompted for text. There are two options:

1. Enter a file extension, which will create a new file with the default filename and the extension you provided.
2. Enter a filename with extension, which will create a file with that name.

## Setup
### Run it as you would any other AppleScript
The easiest way to do this is to drop the script file into your _~/Library/Scripts_ folder and run it from the Script menu in the menu bar. To enable the Script menu, open AppleScript Editor (/Applications/Utilities/AppleScript Editor.app) and  enable the option for "Show Script menu in menu bar" in the AppleScript Editor's preferences window.

### Save it as an application
Open the script in AppleScript Editor and select "Application" from the _Save As_ menu. From there, there are a couple extra steps.

1. **Add the icon file to the Resources folder**  
Right-click your application file and select "Show Package Contents". Open the _Contents/Resources_ folder and drag the included .icns file (or your own, whatever) into this folder. Go ahead and copy the filename to the clipboard.
3. **Alter the icon file key in the plist to enable the icon file.**  
In the _Contents_ folder is your Info.plist file. Open this file in your editor of choice and find the ````CFBundleIconFile```` key. Change the associated ````<string>```` entry (directly after ````<key>CFBundleIconFile</key>````) to reflect the name of your icon file (without the file extension). If you've used the included icon file, your plist file should read:  
````  
<key>CFBundleIconFile</key>
<string>new-file</string>  
````  
Keep that plist file open, dawg...
2. **Add a key to the plist file so the dock icon will remain hidden.**   
In order to keep New File from showing a dock icon (which, IMHO is dumb and pointless for this type of application), you need to _add_ the following to the plist file:  
````
<key>LSUIElement</key>
<string>1</string>
````

## Optional Setup
**Changing the "file exists" behavior**
By default, New File prompts for a new filename if a file by the requested name already exists in the folder. To change this behavior to increment the filename with an appended number, use the ````--prompt:```` flag.

- When ````true````, the script will prompt for a new filename repeatedly until a unique filename is entered.
- When ````false````, the script will increment the filename until it is unique and can be created.

_Example:_
````--prompt: false```` will set New File to increment filenames.

**Changing the default filename**
The default filename for files created by only entering a file extention is "new". To change this, use the ````--filename:```` flag followed by the default filename in quotes.

_Example:_
````--filename: "blank"```` will set the default filename to _blank_. 

### IAQ (Infrequently asked questions)
### Why are you doing this?
I wanted a quick and dead-simple way to add a new file. When saved as an application from AppleScript Editor, and with a few trivial extra steps, New File can be dragged to the Finder toolbar for easy access.

### Okay, so why not just create a Service?
**Short answer**: I do what I want.