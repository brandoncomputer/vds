  trace on
$form1 = dialog create "Hello World" 500 500 500 500
trace off
console "Hey look up above! It's a trace! You can trace every DialogShell function in vds.psm1 back to the powershell level."
console "I suggest limiting the scope of the trace to one or just a few lines like I have done here turning it on and then back off."
wait 1
$OGbutton1 = dialog add $form1 button 200 120 100 20 "Click Me"
$listbox1 = dialog add $form1 checkedlistbox 50 120 300 100
$toolstrip1 = dialog add $form1 toolstrip "Buttonx1|c:\temp\verisign.bmp|Test,-,Buttonx2|c:\temp\verisign.bmps|Test"
$file = dialog add $form1 menustrip "&File" "&Open,-,&Close"
$edit = dialog add $form1 menustrip "&Edit" "&Cut,&Copy"
$popup = dialog popup $form1 "Beans,Rice"

#Two methods to access items created in menu'scope
#Method 1

$script:string = 'Beans'

$timex = timer 10000
$timex.add_Tick({
    $script:string = $string+','+$string
    info $script:string
    dialog popup $form1 $script:string
}
)

function global:menuitemclick ($menu)
{
    switch ($menu.name) {

        "&Open" {
        info $(format '54.67890' '5.2' )}
        "&Cut" {info Cut; evloop "Cut"}
        "Beans" {info Beans; evloop "Beans"}
    }
}

#Method 2
$file.DropDownItems['&Close'].add_Click({info close})
$edit.DropDownItems['&Copy'].add_Click({info Copy; evloop "Copy"})
$popup.Items['Rice'].add_Click({info rice})

#Toolstrip method 1
function global:toolstripitemclick ($name)
{
    switch ($(dlgname $name)) {
        "Buttonx1" {info $(strdel "Brandon" 1 4)}
    }
}

#Toolstrip method 2
$toolstrip1.Items['Buttonx2'].add_Click({info $(filedlg "Text|*.txt" c:\windows)})

#Add some items to the listbox
list add $listbox1 Hi
list add $listbox1 Bye


console "Let's list the properties of form1 below."
console $(dlgprops $form1)
console "Currently the tile is $(dlgprops $form1 "Text") let's change it to New Window Title"
dialog property $form1 "Text" "New Window Title"
console "That's not what we're used to...."
dialog set $form1 "New new Window Title"

console "An array of buttons, define actions for all but '1'"
foreach ($_ in 1..10) 
{ 
   $button = dialog add $form1 button $(sum $(fmul $_ 20) 30) 10 100 20 $_ 
   dialog name $button "button$_" 
    if ($(greater $_ 1))
    { 
        $button.add_Click({ 
        info "Hello from $(dlgtext $this)" 
        evloop $this
        }) 
    } 
} 

console "But what about that first one? We named them all using the $_ object iterator, let's use that"
$controls = $form1.controls
$controls['button1'].add_Click({ 
info $(mod 4 3)
evloop $this
}) 

$timer = timer 1000
#Make certain to dispose of the timer at the end of the script using $ timer.Dispose() otherwise it will re-instance every time you debug "Hint: $ timer.add_Tick({})

$timer.add_Tick({
    $script:tick = $(prod $script:tick)
    console $(mousepos xy)
    if ($(greater $script:tick 2))
    {
    $timer.enabled = $false
    # console "Stop ticking"
    }
     evloop $this
})

# "This version of evloop captures the event that just happened see OGButton1"
function evloop ($a){
    switch ($a){
        OGButton1 {    
            $info = $(chr 34) + "Hello World" + $(chr 34)
            info $info "MyTitle" #Comment: We could have just called called the string directly from the info command, but it's more fun to show a defined object (variable)
            info "Get checked items!"
            foreach ($item in $(the checkeditems of $listbox1))
            {
                switch ($item)
                {
                Hi {info "Hi Hey, I'm item 1!"}
                Bye {info "Bye Hey, I'm item 2!"}
                }
            }
        }

        default {
        if ($a.Text)
        {console "$(dlgtext $a): Top $(dlgpos $a Top) - Left $(dlgpos $a Left) - Width $(dlgpos $a Width) - Height $(dlgpos $a Height)"
         console "$(dlgprops $a Text): Top $(dlgprops $a Top) - Left $(dlgprops $a Left) - Width $(dlgprops $a Width) - Height $(dlgprops $a Height)"
         }
        }
    }
}

$OGbutton1.add_Click({
   evloop "OGButton1"
})

$OGbutton1.add_MouseHover({
    console "you are hovering"
    evloop $this
})


dialog show $form1
#Code pauses execution when the form is shown.

#:CLOSE
$timer.Dispose()
exit
