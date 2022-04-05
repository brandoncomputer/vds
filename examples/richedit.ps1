#add-type -assemblyname System.Drawing

$script:lastfind = ""
$script:curdoc = ""
$RichEditForm       = dialog create "RichEdit" 0 0 600 480
$RichEditForm.MinimumSize = new-object System.Drawing.Size(480,360)
rem $label              = dialog add $RichEditForm Label 25 50 1000 20 "Feel free to make more toobar stuffs!"
$boldbutton         = dialog add $RichEditForm checkbox 52 190 20 20 
$italicbutton       = dialog add $RichEditForm checkbox 52 210 20 20
$underlinebutton    = dialog add $RichEditForm checkbox 52 230 20 20
$leftbutton         = dialog add $RichEditForm checkbox 52 260 20 20
$centerbutton       = dialog add $RichEditForm checkbox 52 280 20 20
$rightbutton        = dialog add $RichEditForm checkbox 52 300 20 20
$StatusStrip1       = dialog add $RichEditForm StatusStrip 
$toolstrip1         = dialog add $RichEditForm toolstrip ('&New|'+$(curdir)+'\..\res\page_add.png,&Open|'+$(curdir)+'\..\res\folder_page_white.png,&Save|'+$(curdir)+'\..\res\disk.png')
$file               = dialog add $RichEditForm menustrip "&File" ('&New|Ctrl+N|'+$(curdir)+'\..\res\page_add.png,&Open|Ctrl+O|'+$(curdir)+'\..\res\folder_page_white.png,&Save|Ctrl+S|'+$(curdir)+'\..\res\disk.png,Save &As,-,Page Set&up...,&Print|Ctrl+P,-,E&xit')
$edit               = dialog add $RichEditForm menustrip "&Edit" "&Undo|Ctrl+Z,-,Cu&t|Ctrl+X,&Copy|Ctrl+C,&Paste|Ctrl+V,-,&Find|Ctrl+F,Find &Next|F3,&Replace|Ctrl+H,&Go To...|Ctrl+G,Select &All|Ctrl+A,Time/&Date|F5"
$format             = dialog add $RichEditForm menustrip "F&ormat" "&Word Wrap,&Font..."
$view               = dialog add $RichEditForm menustrip "&View" "&Status Bar"      
$debug              = dialog add $RichEditForm menustrip "&Debug" "RichEditProps,FontDlgProps"
$FontBox            = dialog add $RichEditForm ComboBox 52 1 121 21 ""  
$SizeBox            = dialog add $RichEditForm ComboBox 52 123 60 21 ""         
$RichEdit           = dialog add $RichEditForm RichTextBox 75 0 480 360
                    dialog image $boldbutton ($(curdir)+'\..\res\text_bold.png')
                    dialog image $italicbutton ($(curdir)+'\..\res\text_italic.png')
                    dialog image $underlinebutton ($(curdir)+'\..\res\text_underline.png')
                    dialog image $leftbutton ($(curdir)+'\..\res\text_align_left.png')
                    dialog image $centerbutton ($(curdir)+'\..\res\text_align_center.png')
                    dialog image $rightbutton ($(curdir)+'\..\res\text_align_right.png')
                    dialog property $boldbutton appearance "Button"
                    dialog property $italicbutton appearance "Button"
                    dialog property $underlinebutton appearance "Button"
                    dialog property $leftbutton appearance "Button"
                    dialog property $centerbutton appearance "Button"
                    dialog property $rightbutton appearance "Button"
                    dialog property $RichEdit Scrollbars "Both"
                    dialog property $RichEdit WordWrap $false
                    dialog property $FontBox DropDownStyle "dropdownlist"  
                    dialog property $SizeBox DropDownStyle "DropDownlist"  
                    
                    list fontlist $FontBox
                                    
                    $(dlgprops $FontBox) | Out-File '.\FontBox.txt'
                    
                    for ($i=8;$(greater 97 $i);$i = $(prod $i))
                    {list add $SizeBox $i}
                    
                    list seek $FontBox 1
                    list seek $SizeBox 1
                    
$leftbutton.add_Click({
    dialog property $RichEdit SelectionAlignment "Left"
})  

$centerbutton.add_Click({
    dialog property $RichEdit SelectionAlignment "Center"
})

$rightbutton.add_Click({
    dialog property $RichEdit SelectionAlignment "Right"
})              
                

$FontBox.add_SelectedIndexChanged({
console "change"
    $rFont = $RichEdit.SelectionFont
    $nFont = new-object Drawing.FontStyle
    $nVal = 0
    if ($(equal $RichEdit.SelectionFont.Bold $true)) {
        $nVal = $nVal + 1
    }
    if ($(equal $RichEdit.SelectionFont.Italic $true)) {
        $nVal = $nVal + 2
    }
    if ($(equal $RichEdit.SelectionFont.Underline $true)) {
        $nVal = $nVal + 4
    }
    $nFont.value__ = $nVal
    $font = New-Object Drawing.Font($FontBox.Text, $rFont.Size, $nFont)
    $RichEdit.SelectionFont = $font
    $RichEdit.Focus()
})

$SizeBox.add_SelectedIndexChanged({
    $rFont = $RichEdit.SelectionFont
    $nFont = new-object Drawing.FontStyle
    $nVal = 0
    if ($(equal $RichEdit.SelectionFont.Bold $true)) {
        $nVal = $nVal + 1
    }
    if ($(equal $RichEdit.SelectionFont.Italic $true)) {
        $nVal = $nVal + 2
    }
    if ($(equal $RichEdit.SelectionFont.Underline $true)) {
        $nVal = $nVal + 4
    }
    $nFont.value__ = $nVal
    $font = New-Object Drawing.Font($rFont.FontFamily, ($SizeBox.Text/1), $nFont)
    $RichEdit.SelectionFont = $font
    $RichEdit.Focus()
})

$script:statusstripvisible = $true      
                
$init = timer 1
$init.add_Tick({
    if ($(equal $scipt:statusstripvisible $true)) {
        dialog setpos $RichEdit 75 0 $(differ $(dlgpos $RichEditForm "W") 15) $(differ $(dlgpos $RichEditForm "H") 140)
    }
    else {
        dialog setpos $RichEdit 75 0 $(differ $(dlgpos $RichEditForm "W") 15) $(differ $(dlgpos $RichEditForm "H") 120)
    }
    $init.enabled = $false
})

$boldbutton.add_Click({
    if ($(equal $RichEdit.SelectionFont.Bold $true)) {
        $rFont = $RichEdit.SelectionFont
        $nFont = new-object Drawing.FontStyle
        $nVal = 0
        if ($(equal $RichEdit.SelectionFont.Italic $true)) {
            $nVal = $nVal + 2
        }
        if ($(equal $RichEdit.SelectionFont.Underline $true)) {
            $nVal = $nVal + 4
        }
        $nFont.value__ = $nVal
        $font = New-Object Drawing.Font($rFont.FontFamily, $rFont.Size, $nFont)
        $RichEdit.SelectionFont = $font
    }
    else {
        $rFont = $RichEdit.SelectionFont
        $nFont = new-object Drawing.FontStyle
        $nVal = 1
        if ($(equal $RichEdit.SelectionFont.Italic $true)) {
            $nVal = $nVal + 2
        }
        if ($(equal $RichEdit.SelectionFont.Underline $true)) {
            $nVal = $nVal + 4
        }
        $nFont.value__ = $nVal      
        $font = New-Object Drawing.Font($rFont.FontFamily, $rFont.Size, $nFont)
        $RichEdit.SelectionFont = $font
    }
    $RichEdit.Focus()
})

$italicbutton.add_Click({
    if ($(equal $RichEdit.SelectionFont.italic $true)) {
        $rFont = $RichEdit.SelectionFont
        $nFont = new-object Drawing.FontStyle
        $nVal = 0
        if ($(equal $RichEdit.SelectionFont.Bold $true)) {
            $nVal = $nVal + 1
        }
        if ($(equal $RichEdit.SelectionFont.Underline $true)) {
            $nVal = $nVal + 4
        }
        $nFont.value__ = $nVal
        $font = New-Object Drawing.Font($rFont.FontFamily, $rFont.Size, $nFont)
        $RichEdit.SelectionFont = $font
    }
    else {
        $rFont = $RichEdit.SelectionFont
        $nFont = new-object Drawing.FontStyle
        $nVal = 2
        if ($(equal $RichEdit.SelectionFont.Bold $true)) {
            $nVal = $nVal + 1
        }
        if ($(equal $RichEdit.SelectionFont.Underline $true)) {
            $nVal = $nVal + 4
        }
        $nFont.value__ = $nVal
        $font = New-Object Drawing.Font($rFont.FontFamily, $rFont.Size, $nFont)
        $RichEdit.SelectionFont = $font
    }
    $RichEdit.Focus()
})

$underlinebutton.add_Click({
    if ($(equal $RichEdit.SelectionFont.underline $true)) {
        $rFont = $RichEdit.SelectionFont
        $nFont = new-object Drawing.FontStyle
        $nVal = 0
        if ($(equal $RichEdit.SelectionFont.Bold $true)) {
            $nVal = $nVal + 1
        }
        if ($(equal $RichEdit.SelectionFont.Italic $true)) {
            $nVal = $nVal + 2
        }
        $nFont.value__ = $nVal
        $font = New-Object Drawing.Font($rFont.FontFamily, $rFont.Size, $nFont)
        $RichEdit.SelectionFont = $font
    }
    else {
        $rFont = $RichEdit.SelectionFont
        $nFont = new-object Drawing.FontStyle
        $nVal = 4
        if ($(equal $RichEdit.SelectionFont.Bold $true)) {
            $nVal = $nVal + 1
        }
        if ($(equal $RichEdit.SelectionFont.Italic $true)) {
            $nVal = $nVal + 2
        }
        $nFont.value__ = $nVal
        $font = New-Object Drawing.Font($rFont.FontFamily, $rFont.Size, $nFont)
        $RichEdit.SelectionFont = $font
    }
    $RichEdit.Focus()
})

$statusupdate = timer 200
$statusupdate.add_Tick({
$row = ($RichEdit.GetLineFromCharIndex($RichEdit.SelectionStart)/1)
$StatusStrip1.items[0].Text = 'Count: '+$RichEdit.text.length+' Lines: '+$RichEdit.Lines.Count+"          Current Line: "+$RichEdit.GetLineFromCharIndex($RichEdit.SelectionStart)+" Current Row: "+$(sendmsg $(winexists $RichEdit) 0x00c1 $RichEdit.SelectionStart 0)
if ($(equal $RichEdit.SelectionFont.Bold $true)) {
    $boldbutton.checked = $true
}
else {
    $boldbutton.checked = $false
}
if ($(equal $RichEdit.SelectionFont.italic $true)) {
    $italicbutton.checked = $true
}
else {
    $italicbutton.checked = $false
}
if ($(equal $RichEdit.SelectionFont.underline $true)) {
    $underlinebutton.checked = $true
}
else {
    $underlinebutton.checked = $false
}
if ($(equal $RichEdit.SelectionAlignment "Left")) {
    $leftbutton.checked = $true
}
else {
    $leftbutton.checked = $false
}
if ($(equal $RichEdit.SelectionAlignment "Center")) {
    $centerbutton.checked = $true
}
else {
    $centerbutton.checked = $false
}
if ($(equal $RichEdit.SelectionAlignment "Right")) {
    $rightbutton.checked = $true
}
else {
    $rightbutton.checked = $false
}
})
            
$RichEditForm.add_Resize({
    if ($(equal $scipt:statusstripvisible $true)) {
        dialog setpos $RichEdit 75 0 $(differ $(dlgpos $RichEditForm "W") 15) $(differ $(dlgpos $RichEditForm "H") 140)
    }
    else {
        dialog setpos $RichEdit 75 0 $(differ $(dlgpos $RichEditForm "W") 15) $(differ $(dlgpos $RichEditForm "H") 120)
    }
})

function global:newdoc {

}

function global:toolstripitemclick ($name) {
    menuitemclick $name
}


function global:menuitemclick ($menu) {
    switch ($(dlgname $menu)) {
        "&New" {    
            if ($(equal $script:curdoc "")) {
                $script:curdoc = ""
                $RichEdit.Clear()
                dialog set $RichEditForm "RichEdit"
            }
            else {
                $saveFile = $(savedlg "Rich Documents|*.rtf")
                if ($saveFile) {
                    $RichEdit.SaveFile($saveFile)
                    $script:curdoc = $(string $saveFile)
                    dialog set $RichEditForm "RichEdit - $(name $curdoc)"
                    $script:curdoc = ""
                    $RichEdit.Clear()
                    dialog set $RichEditForm "RichEdit"
                }
                else {
                    $script:curdoc = ""
                    $RichEdit.Clear()
                    dialog set $RichEditForm "RichEdit"
                }
            }
        }
        "&Open" {
        $fileOpen = $(filedlg "Rich Documents|*.rtf")
            if ($fileOpen) {
                $RichEdit.LoadFile($fileOpen)
                $script:curdoc = $(string $fileOpen)
                dialog set $RichEditForm "RichEdit - $(name $curdoc)"
            }
        }
        "&Save" {
            if ($(equal $script:curdoc "")) {
                $saveFile = $(savedlg "Rich Documents|*.rtf")
                if ($saveFile) {
                    $RichEdit.SaveFile($saveFile)
                    $script:curdoc = $(string $saveFile)
                    dialog set $RichEditForm "RichEdit - $(name $curdoc)"
                }
            }
            else {
                $RichEdit.SaveFile($curdoc)
            }
        }
        "Save &As" {
            $saveFile = $(savedlg "Rich Documents|*.rtf")
            if ($saveFile) {
                $RichEdit.SaveFile($saveFile)
                $script:curdoc = $(string $saveFile)
                dialog set $RichEditForm "RichEdit - $(name $curdoc)"
            }
        }
        "&Print" {
        #Might not be the best way, but this an example.
        $RichEdit.SaveFile($(curdir)+'\print.rtf')
        shell "&Print" ($(curdir)+'\print.rtf')
        }
        "E&xit" {
            if ($(equal $script:curdoc "")) {
                dialog close $RichEditForm
            }
            else {
                $saveFile = $(savedlg "Rich Documents|*.rtf")
                if ($saveFile) {
                    $RichEdit.SaveFile($saveFile)
                    $script:curdoc = $(string $saveFile)
                    dialog set $RichEditForm "RichEdit - $(name $curdoc)"
                    dialog close $RichEditForm
                }
                else {
                    dialog close $RichEditForm
                }
            }
        }
        "&Undo" {$RichEdit.Undo()}
        "Cu&t" {$RichEdit.Cut()}
        "&Copy" {$RichEdit.Copy()}
        "&Paste" {$RichEdit.Paste()}
        "&Font..." {
        $fontdlg = $(fontdlg)
            if ($fontdlg) {
                $RichEdit.SelectionFont = $fontdlg.font
                console $fontdlg.font
                $RichEdit.SelectionColor = $fontdlg.color
            }
        }
        
        "&Find"{
        $script:lastfind = $(input "Find" "Find")
        $RichEdit.Find($script:lastfind)}
        "Find &Next" {$RichEdit.Find($script:lastfind)}
        "&Replace"{replacewindow}
        "&Go To..." {
            $input = $(input "Line" "Go to line")
            window send $(winexists $RichEdit) $(ctrl $(key ("home")))
            #for ($i=1; $i -lt ($input/1); $i++) { 
            for (
                #initialize
                $i = 1
                #stop
                $(greater ($input/1) $i)
                #step
                $i = $(prod $i)
                ) {
                    window send $(winexists $RichEdit) $(key 'Down')
                }
            window send $(winexists $RichEdit) $(shift $(key "End"))
        }
        "Select &All" {
        $RichEdit.SelectAll()}
        "Time/&Date" {
        $RichEdit.SelectedText = $(datetime)
        }
        "&Word Wrap" { 
            if ($(equal $RichEdit.WordWrap $false)) {
                $format.DropDownItems['&Word Wrap'].Checked = $true
                $RichEdit.WordWrap = $true
            }
            else {
                $format.DropDownItems['&Word Wrap'].Checked = $false
                $RichEdit.WordWrap = $false
            }
        }
        "&Status Bar" {
        
            if ($(equal $statusstripvisible $true)) {
            console "Hide"
                $script:statusstripvisible = $false
                window hide $(winexists $StatusStrip1)
                $init.enabled = $true
            }
            else {
            console "Normal"
            $script:statusstripvisible = $true
                window normal $(winexists $StatusStrip1)    
                $init.enabled = $true
            }
                
            
        }
        "RichEditProps"{
        $rFont = $RichEdit.SelectionFont
        $nFont = new-object Drawing.FontStyle
        $nFont.value__ = 3
        $font = New-Object Drawing.Font($rFont.FontFamily, $rFont.Size, $nFont)
        $RichEdit.SelectionFont = $font
        }
    }
}

function replacewindow {
$global:replacewin  = dialog create 'Replace' 0 0 350 175
$what               = dialog add $replacewin label 20 20 75 20 "Find What:"
$global:sfind       = dialog add $replacewin textbox 20 120 120 20 $script:lastfind
$with               = dialog add $replacewin label 60 20 75 20 "Replace With:"
$global:sreplace    = dialog add $replacewin textbox 60 120 120 20
$rfbutton           = dialog add $replacewin button 20 250 75 20 "Find"
$rrbutton           = dialog add $replacewin button 60 250 75 20 "Replace"

$rfbutton.add_Click({
    $script:lastfind = $sfind.text
    $RichEdit.Find($sfind.text)
    $RichEdit.Focus()
})

$rrbutton.add_Click({
    if ($(equal $RichEdit.SelectedText $global:sfind.text)) {
        $RichEdit.SelectedText = $global:sreplace.text
    }
    else {
        $script:lastfind = $global:sfind.text
        $RichEdit.Find($global:sfind.text)
    }
    $RichEdit.Focus()
})
dialog show $global:replacewin
window ontop $(winexists $global:replacewin)
}

dialog show $RichEditForm
