# Visual DialogShell

Visual DialogShell is a way forward for DialogScript syntax within Powershell ~ this project exists to provide a vehicle for the spirit of the DialogScript language to continue - providing a concise, powerful, straightforward language with seemingly untyped variables.

## Does not compile executables, but does create packages that run on endpoints. The installer also contains no executables, you'll hardly notice.

## Further...

### What is DialogShell?
It's like jQuery, but for PowerShell.

### Yes, but what is DialogShell?
DialogShell is a best effort to preserve the DialogScript language, more importantly it's method of operation into a modern format, PowerShell.

### Yes, again, but what is DialogShell?
DialogShell is this PowerShell module. https://github.com/brandoncomputer/vds/blob/master/vds.psm1

### Yes, but there's obviously more than that here, so what is DialogShell?
Visual DialogShell is a visual programming language, a product of DialogShell, which is a PowerShell module. It contains a executable that encompasses the codebase 'compile.exe' that allows you to create new executables in the DialogShell language (derived from PowerShell and DialogScript) for end user applications. Alternately you can call to the codebase vds.psm1 (dialogshell!) and make the deliverable a PowerShell script although this method isn't included in the release it's easy enough to apply from the source code.

### Why do I need DialogShell?
Why should you be interested in DialogShell when C++, C# and Visual Basic are all similarly suited to the task of visual programming? DialogScript is amazing at one thing: The Law of Demeter, or principle of least knowledge. PowerShell is good at this, but not as good as DialogScript. The Law of Demeter is why people love PowerShell, DialogShell builds on this strength to allow users to quickly build powerful solutions. If you are solution oriented, DialogShell should appeal to you.

# Project Board
https://github.com/brandoncomputer/vds/projects/1

## Issue Velocity Points
Leave a comment under any task you'd like to be assigned to in the format [n][n] where n is a fibonacci number, the first representing how complex you feel the issue is, and the second representing how much effort you feel it will take to resolve.  Average the new complexity with the existing complexity number, and the effort with the existing effort number. In the title, the very first [n] gets incremented by 1 if an item is incomplete and on the project board at the end of a week to notate it's tardiness/ability to be reassigned.

I believe in simplicity. If you want to update the project, but don't want to geek out, zip your solution and attach it to the issue comments. I'll review and commit it for you when time permits. You can bug me about it to get it done faster, I don't mind.

# Getting Started
Compile order: 
make.bat (recently simplified)

## Prerequisites

Windows 7 or above with Powershell is the primary prerequisite. 

DialogShell (now) comes with it's own IDE.

For alternative IDE choices, Powershell ISE is good to get started, but Visual Studio Code is more appropriate. I actually settled on Notepad++, and added this to my Run Run Save:
c:\vds\trunk\compile\DialogShell.exe "$(FULL_CURRENT_PATH)" -cpath

DialogShell.exe is partially compatible with Visual Studio Code as a console, but may need more work.

The intent is to continue expanding through PowerShell Core, with the current version being 7, and even expanding into other operating systems. To do so, we need to flip our thinking back to the module vds.psm1 and come up with other unique 'tack ons' for these other systems.

Example script syntax:

```
$form1 =   dialog create "Hello World" 500 500 300 300
$button1 = dialog add $form1 button 10 10 100 20 "Click Me"

$timer = timer 1000
$timer.add_Tick({
console "Tick"
})

$button1.add_Click({
$info = $(chr 34) + "Hello World!" + $(chr 34)
info $info #Comment: We could have just called called the string directly from the info command, but it's more fun to show a defined object (variable)
})

$button1.add_MouseHover({
console "you are hovering!"
})


dialog show $form1

#Code pauses execution when the form is shown.

#:CLOSE

console $(dlgprops $button1)

console "exit"
exit

#END SCRIPT

```

In relation to DialogScript and not necessarily Powershell
----------------------------------------------------------------
(Powershell will not abide comma's. We must get over this and move on.)
$OBJECT - This can be a jumpto, an object or a variable.
$(FUNCTION PARAM1 PARAM2) - This is how function calls are made. 
COMMAND PARAM1 PARAM2 - This is how commands are called.

As seen above a special exception has been made for DIALOG. According to DialogScript, DIALOG would now be a function (@dialog()) but we are not doing that. I do however recommend calling the dialog command as an object that can be acted upon - otherwise you can't act on it. (When you think about it, this was also true in previous implementations of DialogScript, because the dialog command abstracted the user defined name of each dialog object (dialog select,0 or BUTTON1) - so this is arguably a non-change).

New events are available for most objects you are familiar with, use the new function dlgprops $(dlgprops $object) to discover stuff such as $button1.add_MouseHover above, this also can return the value of a property like $(dlgprops $button1 Text).

## Authors

* **Brandon Cunningham** - *Initial work* - brandoncomputer@hotmail.com - forum.vdsworld.com | cnodnarb

## License

This project is licensed under the MIT License - see the [license.md](license.md) file for details

## Acknowledgments
```
Julian Moss (jules)
FreezingFire
Skit3000
Garrett
LiquidCode
Mac
Serge
vdsalchemist
Dr. Dread
CodeScript
PGWARE
jwfv
Tommy
seeminglyscience
DalonP
```
