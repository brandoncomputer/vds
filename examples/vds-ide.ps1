DPIAware
VisualStyle

if ((Get-Module -ListAvailable vds).count -gt 1){
	$global:module = $(path $(Get-Module -ListAvailable vds)[0].path)
}
else {
	$global:module = $(path $(Get-Module -ListAvailable vds).path)
}


directory change "$module\examples"

$ErrorActionPreference = "SilentlyContinue"
$global:findregtabs = 0..100
$global:replaceregtabs = 0..100


#info $(curdir)
#[System.GC]::Collect()
<#
$host.ui.RawUI.Backgroundcolor = 1
cls
console "DialogShell $(sysinfo dsver)"
console "Open Source - vds/pwsh community."
$host.ui.RawUI.WindowTitle = "DialogShell $(sysinfo dsver)"
#>

$global:language = "DialogShell"
$global:theme = "none"

$global:popuprtf = $true

$global:designribbon = $false

    $global:var

$examplepath = [Environment]::GetFolderPath("MyDocuments")+"\DialogShell\examples"
$wizardpath = [Environment]::GetFolderPath("MyDocuments")+"\DialogShell\wizards"
if ($(file ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell\plugins"))){
$global:plugins = ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell\plugins")}
else
{$global:plugins = "$module\plugins"}
$docpath = [Environment]::GetFolderPath("MyDocuments")+"\DialogShell\examples"
$global:nopop = $false


$global:dd = "false"

if (file ".\$(Get-WinSystemLocale)\vds-ide.mui") {
    inifile open ".\$(Get-WinSystemLocale)\vds-ide.mui"
}
else {
    inifile open .\en-US\vds-ide.mui
}

$localefile         = (iniread locale File)
$localenew          = (iniread locale New)
$localenewtt        = (iniread locale Newtt)
$localeopen         = (iniread locale Open)
$localeopentt       = (iniread locale Opentt)
$localesave         = (iniread locale Save)
$localesavett       = (iniread locale Savett)
$localesaveas       = (iniread locale SaveAs)
$localeprint        = (iniread locale Print)
$localeprinttt      = (iniread locale Printtt)
$localeexit			= (iniread locale Exit)
$localeedit         = (iniread locale Edit)
$localeundo         = (iniread locale Undo)
$localeundott       = (iniread locale Undott)
$localecut          = (iniread locale Cut)
$localecuttt        = (iniread locale Cuttt)
$localecopy         = (iniread locale Copy)
$localecopytt       = (iniread locale Copytt)
$localepaste        = (iniread locale Paste)
$localepastett      = (iniread locale Pastett)
$localefind         = (iniread locale Find)
$localefindtt       = (iniread locale Findtt)
$localereplace      = (iniread locale Replace)
$localeselectall    = (iniread locale SelectAll)
$localetimedate     = (iniread locale TimeDate)
$localeview         = (iniread locale View)
$localestatusbar    = (iniread locale StatusBar)
$localerecord       = (iniread locale Record)
$localerecordtt     = (iniread locale Recordtt)
$localeplay         = (iniread locale Play)
$localeplaytt       = (iniread locale Playtt)
$localebuild        = (iniread locale Build)
$localedesigner     = (iniread locale Designer)
$localedesignertt   = (iniread locale Designertt)
$localedebug        = (iniread locale Debug)
$localedebugtt      = (iniread locale Debugtt)
$localecompile      = (iniread locale Compile)
$localecompilett    = (iniread locale Compilett)
$localeexamples     = (iniread locale Examples)
$localesavechanges  = (iniread locale SaveChanges)
$localedialog       = (iniread locale Dialog)
$localemodified     = (iniread locale Modified)
$localezoom         = (iniread locale Zoom)
$localehelp         = (iniread locale Help)
$localeabout        = (iniread locale About)
$localeaboutdialog  = (iniread locale AboutDialog)
$localeplugins      = "&Plugins"
$localedialogshell = "DialogShell"

#lgplv3 - fork located at https://github.com/brandoncomputer/FastColoredTextBox

[Reflection.Assembly]::LoadFile("$(curdir)\FastColoredTextBox.dll") | out-null


$script:lastfind = ""
$script:curdoc = ""

$btscale = 1

#$global:ctscale = ($screen/$vscreen)

$FastTextForm       = dialog create "Visual DialogShell" 0 0 600 480
#$FastTextForm.Font = New-Object System.Drawing.Font("Calibri",8)
$mAssignList = dialog add $FastTextForm ComboBox 0 100 100 50
dialog hide $mAssignList

$FastTextForm.icon = (curdir)+"\..\res\icon.ico"
$FastTextForm.MinimumSize = new-object System.Drawing.Size((480 * $btscale),(360 * $btscale))
$StatusStrip1       = dialog add $FastTextForm StatusStrip 
$closetab           = dialog add $FastTextForm button 0 0 0 0
$toolstrip1         = dialog add $FastTextForm toolstrip ("$localenew|$(curdir)\..\res\page_add.png,$localeopen|$(curdir)\..\res\folder_page_white.png,$localesave|$(curdir)\..\res\disk.png,-,$localeprint|$(curdir)\..\res\printer.png,-,$localeundo|$(curdir)\..\res\arrow_undo.png,-,$localecut|$(curdir)\..\res\cut.png,$localecopy|$(curdir)\..\res\page_copy.png,$localepaste|$(curdir)\..\res\paste_plain.png,-,$localefind|$(curdir)\..\res\page_find.png,-,$localerecord|$(curdir)\..\res\record.png,$localeplay|$(curdir)\..\res\control_play_blue.png,-,$localedialogshell|$(curdir)\..\res\terminal.ico,$localedesigner|$(curdir)\..\res\icon.ico,$localedebug|$(curdir)\..\res\bug_go.png,$localecompile|$(curdir)\..\res\compile.ico")

$toolstrip1.imagescalingsize = new-object System.Drawing.Size([int]($ctscale * 16),[int]($ctscale * 16))
$toolstrip1.Height = $toolstrip1.Height * $ctscale
#$toolstrip1.Items["$localenew"].autosize = $false
#$toolstrip1.Items["$localenew"].margin = new-object System.Windows.Forms.Padding(6, 0, 6, 0)


$file               = dialog add $FastTextForm menustrip "$localefile" ("$localenew|Ctrl+N|$(curdir)\..\res\page_add.png,$localeopen|Ctrl+O|$(curdir)\..\res\folder_page_white.png,$localesave|Ctrl+S|$(curdir)\..\res\disk.png,$localesaveas,-,$localeprint|Ctrl+P|$(curdir)\..\res\printer.png,-,$localeexit|Alt+F4")
$edit               = dialog add $FastTextForm menustrip "$localeedit" ("$localeundo|Ctrl+Z|$(curdir)\..\res\arrow_undo.png,-,$localecut|Ctrl+X|$(curdir)\..\res\cut.png,$localecopy|Ctrl+C|$(curdir)\..\res\page_copy.png,$localepaste|Ctrl+V|$(curdir)\..\res\paste_plain.png,-,$localefind|Ctrl+F|$(curdir)\..\res\page_find.png,$localereplace|Ctrl+H,&Go To...|Ctrl+G,$localeselectall|Ctrl+A,$localetimedate|F5")
$view               = dialog add $FastTextForm menustrip "$localeview" "$localestatusbar,-,50%|Ctrl+5,100%|Ctrl+0,200%|Ctrl+2" 
$build              = dialog add $FastTextForm menustrip "$localebuild" ("$localedialogshell|F3|$(curdir)\..\res\terminal.ico,$localedesigner|F2|$(curdir)\..\res\icon.ico,$localedebug|F8|$(curdir)\..\res\bug_go.png,$localecompile|F9|$(curdir)\..\res\compile.ico")
$mPlugins           = dialog add $FastTextForm menustrip "$localeplugins" 
$help               = dialog add $FastTextForm menustrip "$localehelp" ("$localehelp|F1|$(curdir)\..\res\help.png,$localeabout")               
$FastTab            = dialog add $FastTextForm TabControl 50 0 480 360

$closetab.BackgroundImageLayout = "Zoom"
dialog backgroundimage $closetab ((curdir)+'\..\res\tab_delete.png')

#$closetab.imagescalingsize = new-object System.Drawing.Size([int]($btscale * 16),[int]($btscale * 16))


$popup = dialog popup $FastTextForm ("$localeundo|$(curdir)\..\res\arrow_undo.png,-,$localecut|$(curdir)\..\res\cut.png,$localecopy|$(curdir)\..\res\page_copy.png,$localepaste|$(curdir)\..\res\paste_plain.png,-,$localefind|$(curdir)\..\res\page_find.png,$localereplace,&Go To...,$localeselectall,$localetimedate")

dialog property $toolstrip1.Items["$localenew"] tooltiptext "$localenewtt"
dialog property $toolstrip1.Items["$localeopen"] tooltiptext "$localeopentt"
dialog property $toolstrip1.Items["$localesave"] tooltiptext "$localesavett"
dialog property $toolstrip1.Items["$localeprint"] tooltiptext "$localeprinttt"
dialog property $toolstrip1.Items["$localeundo"] tooltiptext "$localeundott"
dialog property $toolstrip1.Items["$localecut"] tooltiptext "$localecuttt"
dialog property $toolstrip1.Items["$localecopy"] tooltiptext "$localecopytt"
dialog property $toolstrip1.Items["$localepaste"] tooltiptext "$localepastett"
dialog property $toolstrip1.Items["$localefind"] tooltiptext "$localefindtt"
dialog property $toolstrip1.Items["$localerecord"] tooltiptext "$localerecordtt"
dialog property $toolstrip1.Items["$localeplay"] tooltiptext "$localeplaytt"
#dialog property $toolstrip1.Items["$localedesigner"] tooltiptext "$localedesignertt"
#dialog property $toolstrip1.Items["$localedebug"] tooltiptext "$localedebugtt"
#dialog property $toolstrip1.Items["$localecompile"] tooltiptext "$localecompilett"

$FastTab.AllowDrop = $true
$FastTab.add_DragEnter({
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        foreach ($filename in $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop))  {
            switch(ext $filename) {
                dsproj {
                        $scfile = (get-content $filename | Out-String).split((cr))[0]
                        $content = (get-content $scfile | select-object -skip 1)
                        $mAssignList.items.AddRange($content)
                        $FastTab.TabPages.Add($scfile)
                        $FastTab.SelectedIndex = ($FastTab.TabPages.Count - 1)
                        $FastText = New-Object FastColoredTextBoxNS.FastColoredTextBox
                        dialog property $FastText language $language
                        dialog property $FastText dock "Fill"
                        $FastTab.SelectedTab.Controls.Add($FastText)  
                        if ($global:theme -eq "Dark")
                        {$FastText.ForeColor = $light
                        $FastText.BackColor = $dark
                        $FastText.IndentBackColor = $dark}
                        if ($global:theme -eq "Light"){
                        $FastText.ForeColor = $dark
                        $FastText.BackColor = $light
                        $FastText.IndentBackColor = $light}         
                        $FastText.OpenFile($scfile)
                        $script:curdoc = (string $scfile)
                        $FastTab.SelectedTab.Controls[0].IsChanged = $false
                        $init.enabled = $true
                }

                default {
                        $FastTab.TabPages.Add($filename)
                        $FastTab.SelectedIndex = ($FastTab.TabPages.Count - 1)
                        $FastText = New-Object FastColoredTextBoxNS.FastColoredTextBox
                        dialog property $FastText language $language
                        dialog property $FastText dock "Fill"
                        $FastTab.SelectedTab.Controls.Add($FastText) 
                        if ($global:theme -eq "Dark")
                        {$FastText.ForeColor = $light
                        $FastText.BackColor = $dark
                        $FastText.IndentBackColor = $dark}
                        if ($global:theme -eq "Light"){
                        $FastText.ForeColor = $dark
                        $FastText.BackColor = $light
                        $FastText.IndentBackColor = $light}         
                        $FastText.OpenFile($filename)
                        $script:curdoc = (string $filename)
                        $FastTab.SelectedTab.Controls[0].IsChanged = $false
                        $init.enabled = $true
                }
            }
        }
    }
})

Get-ChildItem -Path $plugins -Filter *.ds1 -File -Name | ForEach-Object {
iex $(get-content "$plugins\$_" | out-string)
}

hotkey $FastTextForm 1 ((vkey alt)+(vkey control)) (vkey v)
function global:hotkeyEvent ($a) {
    switch ($a){
        1 {
        $FastTextForm.Text = "Visual DialogShell $(sysinfo dsver)"
        }
    }
}

$FastTab.Add_Click({
        $mAssignList.items.clear()
        $content = (get-content "$(path $FastTab.SelectedTab.Text)\$(name $FastTab.SelectedTab.Text).dsproj" | select-object -skip 1)
        $mAssignList.items.AddRange($content)
        $mFormList.items.clear()
        $content = (get-content "$(path $FastTab.SelectedTab.Text)\$(name $FastTab.SelectedTab.Text).dsproj" | select-object -skip 1)
        $mFormList.items.AddRange($content)
})

$FastTextForm.add_Closing({
    while ($FastTab.TabPages.Count -gt 0) {
        if ($FastTab.SelectedTab.Controls[0].IsChanged -eq $true) {
            $ask = (ask "$localesavechanges" $FastTab.SelectedTab.Text)
            if ($ask -eq "Yes") {
                if (equal $FastTab.SelectedTab.Text "[$localenewtt]") {
                $saveFile = (savedlg "$localedialog")
                    if ($saveFile) {
                        if (equal (ext $saveFile) "dsproj") {
                                $saveFile = "$(path $saveFile)\$(name $saveFile).ds1"
                        }
                                $saveFile | Out-File "$(path $saveFile)\$(name $saveFile).dsproj"
                                add-content -path "$(path $saveFile)\$(name $saveFile).dsproj" -value $mAssignList.Items | out-string
                         
                            
                        $ascii = new-object System.Text.ASCIIEncoding
                        $FastTab.SelectedTab.Controls[0].SaveToFile($saveFile,$ascii)
                        $FastTab.SelectedTab.Controls[0].IsChanged = $false
                        $FastTab.SelectedTab.Text = $saveFile
                                    
                        }
                    }
                    else {
                          $saveFile | Out-File "$(path $saveFile)\$(name $saveFile).dsproj"
                                add-content -path "$(path $saveFile)\$(name $saveFile).dsproj" -value $mAssignList.Items | out-string
                         
                    $saveFile = $FastTab.SelectedTab.Text
                    $ascii = new-object System.Text.ASCIIEncoding
                    $FastTab.SelectedTab.Controls[0].SaveToFile($saveFile,$ascii)
                    $FastTab.SelectedTab.Controls[0].IsChanged = $false
                    }
            $FastTab.SelectedTab.Controls[0].dispose()
            $FastTab.SelectedTab.dispose()
            $init.enabled = $true
            }
            else {
                $FastTab.SelectedTab.Controls[0].dispose()
                $FastTab.SelectedTab.dispose()
                $init.enabled = $true
            }
        }
        else {
            $FastTab.SelectedTab.Controls[0].dispose()
            $FastTab.SelectedTab.dispose()
            $init.enabled = $true
        }
    }
})
                
$closetab.add_Click({
    $indexoftab = $FastTab.SelectedIndex
    if ($FastTab.SelectedTab.Controls[0].IsChanged -eq $true) {
        $ask = (ask "$localesavechanges" $FastTab.SelectedTab.Text)
            if ($ask -eq "Yes") {
                if (equal $FastTab.SelectedTab.Text "[$localenewtt]") {
                    $saveFile = (savedlg "$localedialog")
                    if (equal (ext $saveFile) "dsproj") {
                            $saveFile = "$(path $saveFile)\$(name $saveFile).ds1"
                            }
                            $saveFile | Out-File "$(path $saveFile)\$(name $saveFile).dsproj"
                            add-content -path "$(path $saveFile)\$(name $saveFile).dsproj" -value $mAssignList.Items | out-string
                            
                            $ascii = new-object System.Text.ASCIIEncoding
                            $FastTab.SelectedTab.Controls[0].SaveToFile($saveFile,$ascii)
                            $FastTab.SelectedTab.Controls[0].IsChanged = $false
                    }
                    else {
                    $saveFile | Out-File "$(path $saveFile)\$(name $saveFile).dsproj"
                            add-content -path "$(path $saveFile)\$(name $saveFile).dsproj" -value $mAssignList.Items | out-string
                        $saveFile = $FastTab.SelectedTab.Text
                        $ascii = new-object System.Text.ASCIIEncoding
                        $FastTab.SelectedTab.Controls[0].SaveToFile($saveFile,$ascii)
                        #  $FastTab.SelectedTab.Controls[0].SaveToFile($FastTab.SelectedTab.Text,$ascii)
                        $FastTab.SelectedTab.Controls[0].IsChanged = $false
                    }
                }
                             
            $FastTab.SelectedTab.Controls[0].dispose()
            $FastTab.SelectedTab.dispose()
            $init.enabled = $true
    }
    else {
        $FastTab.SelectedTab.Controls[0].dispose()
        $FastTab.SelectedTab.dispose()
        $init.enabled = $true
    }
    if (($FastTab.TabPages.Count) -gt $indexoftab)
    {$FastTab.SelectedIndex = $indexoftab}
    else{
        if($FastTab.TabPages.Count -gt 0){$FastTab.SelectedIndex = $FastTab.TabPages.Count -1}
    }
    $regtabs[$FastTab.TabPages.Count] = "false"
    $findregtabs[$FastTab.TabPages.Count] = "false"
    $replaceregtabs[$FastTab.TabPages.Count] = "false"
})
                    
$script:statusstripvisible = $true      
                
 $init = timer 1
$init.add_Tick({
    if (equal $script:statusstripvisible $true) {
    dialog setpos $FastTab (50 * $btscale) 0 (differ (dlgpos $FastTextForm "W") (15 * $btscale)) (differ (dlgpos $FastTextForm "H") (115 * $btscale))
    }
    else {
    dialog setpos $FastTab (50 * $btscale) 0 (differ (dlgpos $FastTextForm "W") (15 * $btscale)) (differ (dlgpos $FastTextForm "H") (95 * $btscale))
    }
    if ($FastTab.TabPages.Count -lt 1) {
        dialog hide $closetab}
    else {
        dialog show $closetab
        $closetab.BringToFront()
        dialog setpos $closetab (25 * $btscale) (differ (dlgpos $FastTextForm w) (40 * $btscale)) (25 * $btscale) (25 * $btscale)
        $FastTab.SelectedTab.Controls[0].ShowFoldingLines = $true
    }
    $init.enabled = $false
    
}) 

$statusupdate = timer 200
$statusupdate.enabled = $true
$statusupdate.add_Tick({
    if ($FastTab.TabPages.Count -gt 0) {
            $toolstrip1.items[12].enabled = $true
            $edit.dropdownitems[6].enabled = $true
            $edit.dropdownitems[7].enabled = $true
            $edit.dropdownitems[8].enabled = $true
            $view.dropdownitems[2].enabled = $true
            $view.dropdownitems[3].enabled = $true
            $view.dropdownitems[4].enabled = $true
        #disable 50%
        #disable 100%
        #disable 200%
        #disable macro buttons
        $toolstrip1.items[14].enabled = $true
        $toolstrip1.items[15].enabled = $true
        
        #paste
            $edit.dropdownitems[4].enabled = $true
            $toolstrip1.items[10].enabled = $true
            
            #time/date
            $edit.dropdownitems[10].enabled = $true
            
            if ($FastTab.SelectedTab.Controls[0].TextLength -gt 0) {
        $file.dropdownitems[5].enabled = $true
        $toolstrip1.items[4].enabled = $true
            }
            else{
                    $file.dropdownitems[5].enabled = $false
        $toolstrip1.items[4].enabled = $false}
        
        if ($FastTab.SelectedTab.Controls[0].UndoEnabled)
        {
            $edit.dropdownitems[0].enabled = $true
            $toolstrip1.items[6].enabled = $true
        }
        else
        {$edit.dropdownitems[0].enabled = $false
        $toolstrip1.items[6].enabled = $false
        $FastTab.SelectedTab.Controls[0].IsChanged = $false
        }
    
        if ($FastTab.SelectedTab.Controls[0].IsChanged -eq $true) {
            $StatusStrip1.items[0].Text = "$localemodified     "+"$localezoom "+$FastTab.SelectedTab.Controls[0].zoom+"%"
            $build.dropdownitems[2].enabled = $false
            $build.dropdownitems[3].enabled = $false
            $toolstrip1.items[19].enabled = $false
            $toolstrip1.items[20].enabled = $false
            #disable debug
            #disable compile
            
            #enable save
            $file.dropdownitems[2].enabled = $true
            $toolstrip1.items[2].enabled = $true
        }
        else {
            $StatusStrip1.items[0].Text = $localezoom+": "+$FastTab.SelectedTab.Controls[0].zoom+"%"
            $toolstrip1.items[2].enabled = $false
            $file.dropdownitems[3].enabled = $true
            #disable save button
            $file.dropdownitems[2].enabled = $false
            #disable save menu
            if ($FastTab.SelectedTab.Controls[0].TextLength -gt 0) {
            $build.dropdownitems[2].enabled = $true
            $build.dropdownitems[3].enabled = $true
            $toolstrip1.items[19].enabled = $true
            $toolstrip1.items[20].enabled = $true
            }
        }
        
        if ($FastTab.SelectedTab.Controls[0].selectionlength -eq 0) {
            #disable copy
            $edit.dropdownitems[2].enabled = $false
            $toolstrip1.items[8].enabled = $false
            $edit.dropdownitems[3].enabled = $false
            $toolstrip1.items[9].enabled = $false
            #disable cut
        }
        else {
            #enable copy
            $edit.dropdownitems[2].enabled = $true
            $toolstrip1.items[8].enabled = $true
            $edit.dropdownitems[3].enabled = $true
            $toolstrip1.items[9].enabled = $true
            #enable cut
        }
        if ($FastTab.SelectedTab.Controls[0].TextLength -eq 0)
        {
            $edit.dropdownitems[9].enabled = $false 
        #disable find
        #disable replace
        #disable go to
        #disable select all
            $build.dropdownitems[2].enabled = $false
            $build.dropdownitems[3].enabled = $false
            $toolstrip1.items[19].enabled = $false
            $toolstrip1.items[20].enabled = $false      
        #disable debug
        #disable compile
        }
        else{
            $edit.dropdownitems[9].enabled = $true
            $toolstrip1.items[12].enabled = $true   
        }
        
    }
    else {
        $StatusStrip1.items[0].Text = ""
                #disable save button
        $toolstrip1.items[2].enabled = $false
        $file.dropdownitems[2].enabled = $false
        #disable save as button
        $file.dropdownitems[3].enabled = $false
        #disable print button
        $file.dropdownitems[5].enabled = $false
        $toolstrip1.items[4].enabled = $false
        #disable undo
        $edit.dropdownitems[0].enabled = $false
        $toolstrip1.items[6].enabled = $false
        #disable cut
        #disable copy
            $edit.dropdownitems[2].enabled = $false
            $toolstrip1.items[8].enabled = $false
            $edit.dropdownitems[3].enabled = $false
            $toolstrip1.items[9].enabled = $false
        #disable paste
            $edit.dropdownitems[4].enabled = $false
            $toolstrip1.items[10].enabled = $false
        #disable find
        #disable replace
        #disable go to
        #disable select all
        #disable time/date
            $edit.dropdownitems[6].enabled = $false
            $edit.dropdownitems[7].enabled = $false
            $edit.dropdownitems[8].enabled = $false
            $edit.dropdownitems[9].enabled = $false
            $edit.dropdownitems[10].enabled = $false
            $toolstrip1.items[12].enabled = $false  

        
            $build.dropdownitems[2].enabled = $false
            $build.dropdownitems[3].enabled = $false
            $toolstrip1.items[19].enabled = $false
            $toolstrip1.items[20].enabled = $false
        #disable debug
        #disable compile
        
            $view.dropdownitems[2].enabled = $false
            $view.dropdownitems[3].enabled = $false
            $view.dropdownitems[4].enabled = $false
        #disable 50%
        #disable 100%
        #disable 200%
        #disable macro buttons
        $toolstrip1.items[14].enabled = $false  
        $toolstrip1.items[15].enabled = $false  
        
    }   
})


            
$FastTextForm.add_Resize({
    if (equal $script:statusstripvisible $true) {
    dialog setpos $FastTab (50 * $btscale) 0 (differ (dlgpos $FastTextForm "W") (15 * $btscale)) (differ (dlgpos $FastTextForm "H") (110 * $btscale))
    }
    else {
    dialog setpos $FastTab (50 * $btscale) 0 (differ (dlgpos $FastTextForm "W") (15 * $btscale)) (differ (dlgpos $FastTextForm "H") (90 * $btscale))
    }
    if ($FastTab.TabPages.Count -lt 1) {
        dialog hide $closetab
    }
    else {
        dialog show $closetab
        $closetab.BringToFront()
        dialog setpos $closetab (25 * $btscale) (differ (dlgpos $FastTextForm w) (40 * $btscale)) (25 * $btscale) (25 * $btscale)
    }
})

function global:toolstripitemclick ($name) {
    switch (dlgname $name) {
        "$localerecord" {
            window send $FastTab.SelectedTab.Controls[0].handle (ctrl 'm') 
        }
        "$localeplay" {
            window send $FastTab.SelectedTab.Controls[0].handle (ctrl 'e') 
        }
        default {
            menuitemclick $name
        }
    }
}

function global:menuitemclick ($menu) {
    switch (dlgname $menu) {
        "$localeabout" {
            aboutbox
        }
        
        "$localehelp" {
            run 'start https://dialogshell.com/vds/help/index.php/Special:AllPages'
        }
        "$localedesigner" {
			if ($FastTab.TabPages.Count -eq 0) {
				$FastTab.TabPages.Add("[$localenewtt]")
				$FastTab.SelectedIndex = ($FastTab.TabPages.Count - 1)
				$FastText = New-Object FastColoredTextBoxNS.FastColoredTextBox
				dialog property $FastText language $language
				dialog property $FastText dock "Fill"
				$FastTab.SelectedTab.Controls.Add($FastText)
				if ($global:theme -eq "Dark")
				{$FastText.ForeColor = $light
				$FastText.BackColor = $dark
				$FastText.IndentBackColor = $dark}
				if ($global:theme -eq "Light"){
				$FastText.ForeColor = $dark
				$FastText.BackColor = $light
				$FastText.IndentBackColor = $light}
				$init.enabled = $true
			}

			if ($ctscale -eq 1) {
				$global:eleOK = "true"
				if ($global:dd -eq "false") {
					$global:dd = "true"
					DesignWindow
					elementswindow
					$mForm.Show()
					$mFormList.items.clear()
					$content = (get-content "$(path $FastTab.SelectedTab.Text)\$(name $FastTab.SelectedTab.Text).dsproj" | select-object -skip 1)
					$mFormList.items.AddRange($content)
					[vds]::SetWindowPos($mForm.handle, -1, $(winpos $mForm.handle L), $(winpos $mForm.handle T), $(winpos $mForm.handle W), $(winpos $mForm.handle H), 0x0040)
					[vds]::SetWindowPos($elements.handle, -1, $(winpos $elements.handle L), $(winpos $elements.handle T), $(winpos $elements.handle W), $(winpos $elements.handle H), 0x0040)
					[vds]::SetWindowPos($mFormGroupBox.handle, -1, $(winpos $mFormGroupBox.handle L), $(winpos $mFormGroupBox.handle T), $(winpos $mFormGroupBox.handle W), $(winpos $mFormGroupBox.handle H), 0x0040)
				}
			}
			else {
				if ($(ask "Screen Scale must be 100%. Would you like to launch another session in a compatible mode?") -eq "Yes"){
					switch ((get-host).version.major){
						"7" {
							if ($(ext $FastTab.SelectedTab.Text)) {						
								start-process -filepath pwsh.exe -argumentlist '-ep bypass','-windowstyle hidden','-sta',"-file $(chr 34)$(curdir)\vds-ide-noscale.ps1$(chr 34) $(chr 34)$(path $FastTab.SelectedTab.Text)\$(name $FastTab.SelectedTab.Text).$(ext $FastTab.SelectedTab.Text)$(chr 34)"
							}
							else {
								start-process -filepath pwsh.exe -argumentlist '-ep bypass','-windowstyle hidden','-sta',"-file $(chr 34)$(curdir)\vds-ide-noscale.ps1$(chr 34)"
							}							
						}
				
						default {
							if ($(ext $FastTab.SelectedTab.Text)) {							
								start-process -filepath powershell.exe -argumentlist '-ep bypass','-windowstyle hidden','-sta',"-file $(chr 34)$(curdir)\vds-ide-noscale.ps1$(chr 34) $(chr 34)$(path $FastTab.SelectedTab.Text)\$(name $FastTab.SelectedTab.Text).$(ext $FastTab.SelectedTab.Text)$(chr 34)"
							}
							else {
								start-process -filepath powershell.exe -argumentlist '-ep bypass','-windowstyle hidden','-sta',"-file $(chr 34)$(curdir)\vds-ide-noscale.ps1$(chr 34)"
							}
						}
					}
				}
			}	
		}
		"$localecompile" {
			switch ((get-host).version.major){
				"7" {
					if (file ((path $FastTab.SelectedTab.Text)+'\'+$(name $FastTab.SelectedTab.Text)+'.pil'))
					{
						start-process -filepath pwsh.exe -argumentlist '-ep bypass','-windowstyle hidden','-sta',"-file $(chr 34)$(curdir)\..\compile\compile-gui.ps1$(chr 34) $(chr 34)$(path $FastTab.SelectedTab.Text)\$(name $FastTab.SelectedTab.Text).pil$(chr 34) $(chr 34)$(curdir)\..\compile$(chr 34)"

					}
					else {
						if ($FastTab.SelectedTab.Text -ne "[$localenewtt]") {
							if ($FastTab.TabPages.Count -gt 0) {
								inifile open ((path $FastTab.SelectedTab.Text)+'\'+(name $FastTab.SelectedTab.Text)+'.pil')
								inifile write compile inputfile $FastTab.SelectedTab.Text
								inifile write compile outputfile ((path $FastTab.SelectedTab.Text)+'\'+(name $FastTab.SelectedTab.Text)+'.cmd')
						start-process -filepath pwsh.exe -argumentlist '-ep bypass','-windowstyle hidden','-sta',"-file $(chr 34)$(curdir)\..\compile\compile-gui.ps1$(chr 34) $(chr 34)$(path $FastTab.SelectedTab.Text)\$(name $FastTab.SelectedTab.Text).pil$(chr 34) $(chr 34)$(curdir)\..\compile$(chr 34)"

							}
							else { 
							start-process -filepath pwsh.exe -argumentlist '-ep bypass','-windowstyle hidden','-sta',"-file $(chr 34)$(curdir)\..\compile\compile-gui.ps1$(chr 34)"
							}
						}
						else {
						 start-process -filepath pwsh.exe -argumentlist '-ep bypass','-windowstyle hidden','-sta',"-file $(chr 34)$(curdir)\..\compile\compile-gui.ps1$(chr 34)"
						}
					}						
				}
		
				default {
					if (file ((path $FastTab.SelectedTab.Text)+'\'+$(name $FastTab.SelectedTab.Text)+'.pil'))
					{
						start-process -filepath powershell.exe -argumentlist '-ep bypass','-windowstyle hidden','-sta',"-file $(chr 34)$(curdir)\..\compile\compile-gui.ps1$(chr 34) $(chr 34)$(path $FastTab.SelectedTab.Text)\$(name $FastTab.SelectedTab.Text).pil$(chr 34) $(chr 34)$(curdir)\..\compile$(chr 34)"

					}
					else {
						if ($FastTab.SelectedTab.Text -ne "[$localenewtt]") {
							if ($FastTab.TabPages.Count -gt 0) {
								inifile open ((path $FastTab.SelectedTab.Text)+'\'+(name $FastTab.SelectedTab.Text)+'.pil')
								inifile write compile inputfile $FastTab.SelectedTab.Text
								inifile write compile outputfile ((path $FastTab.SelectedTab.Text)+'\'+(name $FastTab.SelectedTab.Text)+'.cmd')
						start-process -filepath powershell.exe -argumentlist '-ep bypass','-windowstyle hidden','-sta',"-file $(chr 34)$(curdir)\..\compile\compile-gui.ps1$(chr 34) $(chr 34)$(path $FastTab.SelectedTab.Text)\$(name $FastTab.SelectedTab.Text).pil$(chr 34) $(chr 34)$(curdir)\..\compile$(chr 34)"

							}
							else { 
							start-process -filepath powershell.exe -argumentlist '-ep bypass','-windowstyle hidden','-sta',"-file $(chr 34)$(curdir)\..\compile\compile-gui.ps1$(chr 34)"
							}
						}
						else {
						 start-process -filepath powershell.exe -argumentlist '-ep bypass','-windowstyle hidden','-sta',"-file $(chr 34)$(curdir)\..\compile\compile-gui.ps1$(chr 34)"
						}
					}
				}

			}			
        }
        "100%" {
            $FastTab.SelectedTab.Controls[0].Zoom = 100
        }
        "50%" {
            $FastTab.SelectedTab.Controls[0].Zoom = 50
        }
        "200%" {
            $FastTab.SelectedTab.Controls[0].Zoom = 200
            
        }
        "$localedialogshell" {
  
        $curdir = $(curdir)
              if ($(file $(string $FastTab.SelectedTab.Text)))
                {
                    directory change $(path $(string $FastTab.SelectedTab.Text))
                }
			switch ((get-host).version.major){
				"7" {
					start-process -filepath pwsh.exe -argumentlist '-ep bypass','-sta',"-file $(chr 34)$curdir\..\compile\dialogshell.ps1$(chr 34)"
				}
				default {
					start-process -filepath powershell.exe -argumentlist '-ep bypass','-sta',"-file $(chr 34)$curdir\..\compile\dialogshell.ps1$(chr 34)"
				}
			}				
             directory change $curdir
    }
      "$localedebug" {
            if ($FastTab.SelectedTab.Controls[0].IsChanged -eq $true) {
                $ask = (ask "$localesavechanges" $FastTab.SelectedTab.Text)
                if ($ask -eq "Yes") {
                    if (equal $FastTab.SelectedTab.Text "[$localenewtt]") {
                    $saveFile = (savedlg "$localedialog")
                        if ($saveFile) {
                            if (equal (ext $saveFile) "dsproj") {
                                    $saveFile = "$(path $saveFile)\$(name $saveFile).ds1"
                                    }
                                    $saveFile | Out-File "$(path $saveFile)\$(name $saveFile).dsproj"
                                    add-content -path "$(path $saveFile)\$(name $saveFile).dsproj" -value $mAssignList.Items | out-string
                            
                                $ascii = new-object System.Text.ASCIIEncoding
                                $FastTab.SelectedTab.Controls[0].SaveToFile($saveFile,$ascii)
                                $FastTab.SelectedTab.Controls[0].IsChanged = $false
                                $FastTab.SelectedTab.Text = $saveFile
                            
                        }
                    }   
                    else {
                    $saveFile | Out-File "$(path $saveFile)\$(name $saveFile).dsproj"
                            add-content -path "$(path $saveFile)\$(name $saveFile).dsproj" -value $mAssignList.Items | out-string
                        $saveFile = $FastTab.SelectedTab.Text
                        $ascii = new-object System.Text.ASCIIEncoding
                        $FastTab.SelectedTab.Controls[0].SaveToFile($saveFile,$ascii)
                        $FastTab.SelectedTab.Controls[0].IsChanged = $false
                    }
                } 
            }
            $curdir = $(curdir)
            directory change $(path $(string $FastTab.SelectedTab.Text))
            $StatusStrip1.items[0].Text = "DEBUGGING...."
			switch ((get-host).version.major){
				"7" {
					start-process -filepath pwsh.exe -argumentlist '-ep bypass','-sta',"-file $(chr 34)$curdir\..\compile\dialogshell.ps1$(chr 34) $(chr 34)$(string $FastTab.SelectedTab.Text)$(chr 34) -cpath"

				}
				default {
					start-process -filepath powershell.exe -argumentlist '-ep bypass','-sta',"-file $(chr 34)$curdir\..\compile\dialogshell.ps1$(chr 34) $(chr 34)$(string $FastTab.SelectedTab.Text)$(chr 34) -cpath"

				}
			}	
             
            directory change $curdir
            $StatusStrip1.items[0].Text = ""
        }
        
        "$localenew" {    
            $FastTab.TabPages.Add("[$localenewtt]")
            $FastTab.SelectedIndex = ($FastTab.TabPages.Count - 1)
            $FastText = New-Object FastColoredTextBoxNS.FastColoredTextBox
            dialog property $FastText language $language
            dialog property $FastText dock "Fill"
          #  dialog property $FastText backcolor "Silver"
          #  (dialog properties $FastText | Out-File c:\temp\FastText.txt)
            $FastTab.SelectedTab.Controls.Add($FastText)
            if ($global:theme -eq "Dark")
            {$FastText.ForeColor = $light
            $FastText.BackColor = $dark
            $FastText.IndentBackColor = $dark}
            if ($global:theme -eq "Light"){
            $FastText.ForeColor = $dark
            $FastText.BackColor = $light
            $FastText.IndentBackColor = $light}
            $init.enabled = $true
        }
        "$localeopen" {
            $fileOpen = (filedlg "$localedialog")
            if ($fileOpen) {
                if (equal (ext $fileOpen) "dsproj"){
                $content = (get-content $fileOpen | select-object -skip 1)
                $mAssignList.items.AddRange($content)
                    $fileOpen = (get-content $fileOpen | Out-String).split((cr))[0]
                }
                $FastTab.TabPages.Add("$fileOpen")
                $FastTab.SelectedIndex = ($FastTab.TabPages.Count - 1)
                $FastText = New-Object FastColoredTextBoxNS.FastColoredTextBox
                dialog property $FastText language $language
                dialog property $FastText dock "Fill"
                $FastTab.SelectedTab.Controls.Add($FastText)    
            if ($global:theme -eq "Dark")
            {$FastText.ForeColor = $light
            $FastText.BackColor = $dark
            $FastText.IndentBackColor = $dark}
            if ($global:theme -eq "Light"){
            $FastText.ForeColor = $dark
            $FastText.BackColor = $light
            $FastText.IndentBackColor = $light}
                $FastText.OpenFile($fileOpen)
                $script:curdoc = (string $fileOpen)
            }
            $FastTab.SelectedTab.Controls[0].IsChanged = $false
            $init.enabled = $true
        }
        
        "$localesave" {
            if (equal $FastTab.SelectedTab.Text "[$localenewtt]") {
                $saveFile = (savedlg "$localedialog")
                if ($saveFile) {
                        if (equal (ext $saveFile) "dsproj") {
                            $saveFile = "$(path $saveFile)\$(name $saveFile).ds1"
                            }
                            $saveFile | Out-File "$(path $saveFile)\$(name $saveFile).dsproj"
                            add-content -path "$(path $saveFile)\$(name $saveFile).dsproj" -value $mAssignList.Items | out-string
                            
                            $ascii = new-object System.Text.ASCIIEncoding
                            $FastTab.SelectedTab.Controls[0].SaveToFile($saveFile,$ascii)
                            $FastTab.SelectedTab.Controls[0].IsChanged = $false
                            $FastTab.SelectedTab.Text = $saveFile
                        }
                }
                    
            
            else {
            $saveFile = $FastTab.SelectedTab.Text
            $saveFile | Out-File "$(path $saveFile)\$(name $saveFile).dsproj"
                            add-content -path "$(path $saveFile)\$(name $saveFile).dsproj" -value $mAssignList.Items | out-string
                $ascii = new-object System.Text.ASCIIEncoding
                $FastTab.SelectedTab.Controls[0].SaveToFile($FastTab.SelectedTab.Text,$ascii)
                $FastTab.SelectedTab.Controls[0].IsChanged = $false
            }
            $init.enabled = $true
        }
        "$localesaveas" {
            $saveFile = (savedlg "$localedialog")
                if ($saveFile) {
                    if (equal (ext $saveFile) "dsproj") {
                        $saveFile = "$(path $saveFile)\$(name $saveFile).ds1"
                        }
                        $saveFile | Out-File "$(path $saveFile)\$(name $saveFile).dsproj"
                        add-content -path "$(path $saveFile)\$(name $saveFile).dsproj" -value $mAssignList.items | out-string
                    
                    $ascii = new-object System.Text.ASCIIEncoding
                    $FastTab.SelectedTab.Controls[0].SaveToFile($saveFile,$ascii)
                    $FastTab.SelectedTab.Controls[0].IsChanged = $false
                    $FastTab.SelectedTab.Text = $saveFile
                }
            $init.enabled = $true
        }
        "$localeprint" {
            $FastTab.SelectedTab.Controls[0].Print()
        }
        "$localeexit" {

            dialog close $FastTextForm
     
        }
        "$localeundo" {$FastTab.SelectedTab.Controls[0].Undo()}
        "$localecut" {$FastTab.SelectedTab.Controls[0].Cut()}
        "$localecopy" {$FastTab.SelectedTab.Controls[0].Copy()}
        "$localepaste" {$FastTab.SelectedTab.Controls[0].Paste()}
        "$localefind" {$FastTab.SelectedTab.Controls[0].ShowFindDialog()
        if ($findregtabs[$FastTab.SelectedIndex] -ne "true") {
        $findregtabs[$FastTab.SelectedIndex] = $true
        [vds]::SetWindowPos($(winexists "Find"), -2, $(winpos $FastTab.handle W) - $(winpos $(winexists "Find") W) - 30, 0, $(winpos $(winexists "Find") W), $(winpos $(winexists "Find") H),0x0040)
        window fuse ($(winexists "Find")) $FastTab.SelectedTab.Handle
        }
       
       }
        "$localereplace" {$FastTab.SelectedTab.Controls[0].ShowReplaceDialog()
        if ($replaceregtabs[$FastTab.SelectedIndex] -ne "true") {
        $replaceregtabs[$FastTab.SelectedIndex] = $true
        [vds]::SetWindowPos($(winexists "Find and replace"), -2, $(winpos $FastTab.handle W) - $(winpos $(winexists "Find and replace") W) - 30 , 135, $(winpos $(winexists "Find and replace") W), $(winpos $(winexists "Find and replace") H),0x0040)
        window fuse ($(winexists "Find and replace")) $FastTab.SelectedTab.Handle
    }
        }
        "&Go To..." { $FastTab.SelectedTab.Controls[0].ShowGotoDialog()
    }
        "$localeselectall" {$FastTab.SelectedTab.Controls[0].SelectAll()}
        "$localetimedate" {$FastTab.SelectedTab.Controls[0].SelectedText = (datetime)}
        "&Word Wrap" { 
        if (equal $FastText.WordWrap $false) {
                $format.DropDownItems['&Word Wrap'].Checked = $true
                $FastText.WordWrap = $true
            }
            else {
                $format.DropDownItems['&Word Wrap'].Checked = $false
                $FastText.WordWrap = $false
            }
        }
        "$localestatusbar" {
            if (equal $statusstripvisible $true) {
           # console "Hide"
                $script:statusstripvisible = $false
                window hide (winexists $StatusStrip1)
                $init.enabled = $true
            }
            else {
                # console "Normal"
            $script:statusstripvisible = $true
                window normal (winexists $StatusStrip1)    
                $init.enabled = $true
            }                       
        }
    } 
    if ($(file $popmenupath))
    {iex (get-content $popmenupath | out-string)}
}



function aboutbox {
    $AboutForm = dialog create "About Visual DialogShell" 0 0 (725 * $btscale) (480 * $btscale)
    $PictureBox1 = dialog add $AboutForm PictureBox 37 68 100 50 
    dialog property $PictureBox1 BorderStyle "Fixed3D"  
    $PictureBox2 = dialog add $AboutForm PictureBox 59 44 100 50 
    dialog property $PictureBox2 BorderStyle "Fixed3D"  
    $PictureBox3 = dialog add $AboutForm PictureBox 37 29 100 50 
    dialog property $PictureBox3 BorderStyle "Fixed3D"  
    $PictureBox4 = dialog add $AboutForm PictureBox 22 23 150 100 
    dialog property $PictureBox4 BorderStyle "Fixed3D"  
    dialog property $PictureBox1 backcolor lightblue
    dialog property $PictureBox2 backcolor lightblue
    dialog property $PictureBox3 backcolor lightblue
 #   dialog property $PictureBox3 backcolor $(color rgb 0 0 255)
    $string = "Visual DialogShell $(cr)$(lf)$(cr)$(lf)Unless otherwise mentioned, this is the fruit of an MIT Open sourced project located at https://github.com/brandoncomputer/vds, some portions are CC by SA, others are lgplv3, and some are MSPL.$(cr)$(lf)This software is meant for the quickest freshest on the fly windows programs ever. Get more done, in less time, by using simpler tools. $(cr)$(lf)PowerShell compatible.$(cr)$(lf) A very special thanks to Julian Moss, the creator of DialogScript, for introducing me to the world of computer programming.$(cr)$(lf)$(cr)$(lf)Copyright 2019 Brandon Cunningham$(cr)$(lf)Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the $(chr 34)Software$(chr 34)), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:$(cr)$(lf)The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.$(cr)$(lf)THE SOFTWARE IS PROVIDED $(chr 34)AS IS$(chr 34), WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."  
    #  $string = "$localeaboutdialog"
    $Label1 = dialog add $AboutForm label 21 188 (500 * $btscale) (500 * $btscale) $string
    dialog property $Label1 font "Segoe UI Black, 8"
    $Buttonx = dialog add $AboutForm button (400 * $btscale) (400 * $btscale) (40 * $btscale) (20 * $btscale) "OK"
    $Buttonx.BringToFront()
    $Buttonx.add_Click({dialog close $AboutForm})
    
    $AboutForm.icon = (curdir)+"\..\res\icon.ico"
    
    dialog showmodal $AboutForm
}
    
#Adapted from Z.Alex https://gallery.technet.microsoft.com/scriptcenter/Powershell-Form-Builder-3bcaf2c7 MIT License

$global:openform = ""

function mouseDown {
 
    $Global:mCurFirstX = $(mousepos x)
    $Global:mCurFirstY = $(mousepos y)
 
} 
 
function mouseMove ($mControlName) { 
 
    $mCurMoveX = $(mousepos x) 
    $mCurMoveY = $(mousepos y) 

   if (($(not $(equal $Global:mCurFirstX 0))) -and ($(not $(equal $Global:mCurFirstY 0)))){ 
  
        $mDifX = $(differ $Global:mCurFirstX $mCurMoveX)  
        $mDifY = $(differ $Global:mCurFirstY $mCurMoveY) 
          
          dialog cursor $mFormGroupBox SizeAll
        dialog setpos $this $(differ $this.top $mDifY) $(differ $this.left $mDifX) $this.width $this.height
  
         $Global:mCurFirstX = $mCurMoveX  
        $Global:mCurFirstY = $mCurMoveY  
 
    } 
 
} 
 
function mouseUP ($mControlObj) { 
 
 dialog cursor $mFormGroupBox Arrow
    $mCurUpX = $(mousepos x) 
    $mCurUpY = $(mousepos y) 
 
    $Global:mCurFirstX = 0 
    $Global:mCurFirstY = 0 
 
 
    Foreach ($mElement In $(the Elements $Global:mFormObj)) { 
 
       
        if ($(equal $mElement.name $this.name)) {

            foreach($mProp in $(the Properties $mElement)){ 
              
                Switch($mProp.name) { 
 
                    'Top'{ $mProp.Value = $this.top} 
                    'Left'{$mProp.Value = $this.left} 
 
                } 
            } 
        } 
    } 
     
    renewGrids $this.name
} 
 
Function renewGrids ($a){ 

    $mList = New-Object System.Collections.ArrayList 
    [array]$mElementsArr = $mFormObj.Elements | select Name,Type 
    $mList.AddRange($mElementsArr) 
    $mElemetnsGrid.DataSource =  $mList 
       $mElemetnsGrid.Columns[1].ReadOnly = $true 
    $mElemetnsGrid.Columns[0].Width = '140'
    $mElemetnsGrid.Columns[1].Width = '140'
 
     $mList2 = New-Object System.Collections.ArrayList 

    [array]$mPropertyArr = $mFormObj.Elements[$mElemetnsGrid.CurrentRow.Index].Properties

    $mList2.AddRange($mPropertyArr) 
    $mPropertiesGrid.DataSource = $mList2 
       $mPropertiesGrid.Columns[0].ReadOnly=$true
    $mPropertiesGrid.Columns[0].Width = '140'
    $mPropertiesGrid.Columns[1].Width = '140'
    

         $mElemetnsGrid.CurrentCell = $null
$i = -1
    foreach($row in $(the Rows $mElemetnsGrid))
{
    $i++
    if($(equal $row.Cells[0].Value.ToString() $a))
    {

 $mElemetnsGrid.CurrentCell = $mElemetnsGrid[0,$i]
       $row.selected = $true
  }
 ElementsChanged
}


 
} 
 
Function DeleteElement { 
    $ev = $mFormObj.Elements[$mElemetnsGrid.CurrentRow.Index].Name
    if ($(greater $mFormObj.Elements.Count 1)){
        $Global:mFormObj.Elements = $mFormObj.Elements | where{$(not $(equal $(the Name $_) $ev))}
    }
    else{
        $Global:mFormObj.Elements = @()
    }
    
    $fc = $mFormGroupBox.Controls

    $fc[$ev].Dispose()
    
    renewGrids $mFormGroupBox.Controls[0]
}     
   

 
Function AddProperty ($mName,$mValue){ 
 
    $mPropertyObj = New-Object PSCustomObject 
    $mPropertyObj | Add-Member -Name 'Name' -MemberType NoteProperty -Value $mName 
    $mPropertyObj | Add-Member -Name 'Value' -MemberType NoteProperty -Value $mValue 
    return $mPropertyObj 
 
} 
 
Function ElementsChanged{ 

 $mSameType = ($mFormObj.Elements | where{$(like $_.Type $mControlType.SelectedItem)})

    if ($mElemetnsGrid.CurrentRow.Index)
    {
    $mList2 = New-Object System.Collections.ArrayList 
    [array]$mPropertyArr =  $mFormObj.Elements[$mElemetnsGrid.CurrentRow.Index].Properties
    $mList2.AddRange($mPropertyArr) 
    $mPropertiesGrid.DataSource = $mList2 
    }

 
} 
 
function ElementsEndEdit { 
 
    $Global:mFormObj.Elements[$mElemetnsGrid.CurrentRow.Index].Name =  $mElemetnsGrid.CurrentCell.FormattedValue 
    repaintForm 
 
} 
 
 
 
Function AddElement { 
    $mPropertiesArr =@() 
    
    $mSameType = ($mFormObj.Elements | ?{$(like $_.Type $mControlType.SelectedItem)}) 
 
    if($(the count $mSameType) -ne $NUll -and $(not $(null $mSameType))) { #compare to below [fun with linguistic semantics]
 $tr = $true
        $mControlName=''+$mControlType.SelectedItem+($mSameType.count+1) 
 
     }elseif($(null $mSameType.Count) -and $(not $(equal $mSameType $null))) {  #compare to above
 $tr = $true
        $mControlName=''+$mControlType.SelectedItem+'2' 
 
     }else{ 
      $tr = $true
        $mControlName=''+$mControlType.SelectedItem+'1' 
      
     } 

     $d1 = $mControlType.SelectedItem | Out-String
        
        $d1 = $d1.trim()
        
     $dummy = New-Object System.Windows.Forms.$d1
     $mForm.controls.Add($dummy)

  #  $mPropertiesArr+= AddProperty 'Text' $mControlName 
    $mPropertiesArr+= AddProperty 'Width' $dummy.width 
    $mPropertiesArr+= AddProperty 'Height' $dummy.height 
    $mPropertiesArr+= AddProperty 'Top' $(Get-Random -Minimum 20 -Maximum ($mFormGroupBox.Height - $dummy.Height))
    $mPropertiesArr+= AddProperty 'Left' $(Get-Random -Minimum 20 -Maximum ($mFormGroupBox.width - $dummy.Width))
    $mForm.controls.remove($dummy)

 
    $mElementsObj = New-Object PSCustomObject 
    $mElementsObj |Add-Member -Name 'Name' -MemberType NoteProperty -Value $mControlName  
    $mElementsObj |Add-Member -Name 'Type' -MemberType NoteProperty -Value ($mControlType.SelectedItem) 
    $mElementsObj |Add-Member -Name 'Properties' -MemberType NoteProperty -Value $mPropertiesArr 
    $Global:mFormObj.Elements += $mElementsObj 
 
    renewGrids 
 
    repaintForm 
 
} 

Function AddElement2 ($a, $filename) { 
    $mPropertiesArr =@() 
    $a = $a.trim()
 
    $mSameType = ($mFormObj.Elements | ?{$_.Type -like $a}) 

    #Strange hybrid language powers activate! Form of DialogShell! Form of Powershell!
 
    if($(the count $mSameType) -ne $NUll -and $(not $(null $mSameType))) { #compare to below [fun with linguistic semantics]
 $tr = $true
        $mControlName=''+$a+($mSameType.count+1) 
 
     }elseif($(null $mSameType.Count) -and $(not $(equal $mSameType $null))) {  #compare to above
      
 $tr = $true
        $mControlName=''+$a+'2' 
 
     }else{ 
      $tr = $true
        $mControlName=''+$a+'1' 
      
     } 

     $d1 = $a | Out-String
     
     $d1 = $d1.trim()

     switch ($d1){
 
 "Form" {
 $mPropertiesArr+= AddProperty 'Name' $nameref
 $mPropertiesArr+= AddProperty 'Height' $nameref
 $mPropertiesArr+= AddProperty 'Width' $nameref
 }
     
 "StatusStrip" {}
     
      "ToolStrip" {
     #  $dummy = dialog add $mForm $d1
$mPropertiesArr+= AddProperty 'Item1' '&Item|Image'
$mPropertiesArr+= AddProperty 'Item2'
$mPropertiesArr+= AddProperty 'Item3' 
$mPropertiesArr+= AddProperty 'Item4' 
$mPropertiesArr+= AddProperty 'Item5'
$mPropertiesArr+= AddProperty 'Item6'
$mPropertiesArr+= AddProperty 'Item7'
$mPropertiesArr+= AddProperty 'Item8'
$mPropertiesArr+= AddProperty 'Item9'
$mPropertiesArr+= AddProperty 'Item10'
$mPropertiesArr+= AddProperty 'Item11'
$mPropertiesArr+= AddProperty 'Item12'
$mPropertiesArr+= AddProperty 'Item13'
$mPropertiesArr+= AddProperty 'Item14'
$mPropertiesArr+= AddProperty 'Item15'
$mPropertiesArr+= AddProperty 'Item16'
$mPropertiesArr+= AddProperty 'Item17'
$mPropertiesArr+= AddProperty 'Item18'
$mPropertiesArr+= AddProperty 'Item19'
$mPropertiesArr+= AddProperty 'Item20'

}
     
     "MenuStrip" {
     #  $dummy = dialog add $mForm $d1
$mPropertiesArr+= AddProperty 'Item1' '&Item|Hotkey|Image'
$mPropertiesArr+= AddProperty 'Item2' '-'
$mPropertiesArr+= AddProperty 'Item3' 'X Form to Repaint'
$mPropertiesArr+= AddProperty 'Item4' 
$mPropertiesArr+= AddProperty 'Item5'
$mPropertiesArr+= AddProperty 'Item6'
$mPropertiesArr+= AddProperty 'Item7'
$mPropertiesArr+= AddProperty 'Item8'
$mPropertiesArr+= AddProperty 'Item9'
$mPropertiesArr+= AddProperty 'Item10'
$mPropertiesArr+= AddProperty 'Item11'
$mPropertiesArr+= AddProperty 'Item12'
$mPropertiesArr+= AddProperty 'Item13'
$mPropertiesArr+= AddProperty 'Item14'
$mPropertiesArr+= AddProperty 'Item15'
$mPropertiesArr+= AddProperty 'Item16'
$mPropertiesArr+= AddProperty 'Item17'
$mPropertiesArr+= AddProperty 'Item18'
$mPropertiesArr+= AddProperty 'Item19'
$mPropertiesArr+= AddProperty 'Item20'

}

default{
    
 $dummy = dialog add $mForm $d1
 
    $mPropertiesArr+= AddProperty 'Text' $mControlName 
    $mPropertiesArr+= AddProperty 'Width' $dummy.width 
    $mPropertiesArr+= AddProperty 'Height' $dummy.height 
    $x = $(mousepos x) - $mFormGroupBox.Left
    $y = $(mousepos y) - $mFormGroupBox.Top
    $mPropertiesArr+= AddProperty 'Top' "$([Math]::Round(($y - ($dummy.height/2)),0))"
    $mPropertiesArr+= AddProperty 'Left' "$([Math]::Round(($x - ($dummy.width/2)),0))"
    
    
    
 
foreach ($object in ($dummy | get-member)){
    if ($object.membertype.toString() -eq "Property"){
        switch ($object.name){
            'Text' {}
            'Width' {}
            'Height' {}
            'Top' {}
            'Left' {}
'AccessibilityObject' {}
'CanFocus' {}
'CanSelect' {}
'CompanyName' {}
'Container' {}
'ContainsFocus' {}
'Controls' {}
'Created' {}
'DataBindings' {}
'DeviceDpi' {}
'DisplayRectangle' {}
'Disposing' {}
'Focused' {}
'Handle' {}
'HasChildren' {}
'InvokeRequired' {}
'IsDisposed' {}
'IsHandleCreated' {}
'IsMirrored' {}
'LayoutEngine' {}
'PreferredHeight' {}
'PreferredSize' {}
'ProductName' {}
'ProductVersion' {}
'RecreatingHandle' {}
'Right' {}
'AccessibleName' {}
'AccessibleDefaultActionDescription' {}
'AccessibleDescription' {}
'AccessibleRole' {}
'ImeMode' {}
'IsAccessible' {}
'Location' {}
'Name' {}
'Parent' {}
'Region' {}
'Site' {}
'WindowTarget' {}
            default{
            $mPropertiesArr+= AddProperty $object.name $object.value
            }
        }
    }
}

}
    
}
    dialog remove $dummy

  <#  
    $gate = $false
        if ($filename)
    {
    $content = get-content $filename
if ($content) {

try{
    $Items = New-Object System.Collections.Generic.List[System.Object]
     $Items.AddRange($content) 
    foreach ($Item in $Items)
    {
        if ($(equal $Item "[InternetShortcut]"))
        {$gate = $true}
        if ($(equal $gate $false))
        {
            $entry = $Item.split("=")[0]
            if ($(equal $entry "Text"))
                {$value = $mControlName}
            else
            {
                $value = $item.split("=")[1]
            }
            $mPropertiesArr+= AddProperty $entry $value
        }               
    }   
}

catch { $entry = $content.split("=")[0]
        if ($(equal $entry "Text"))
        {$value = $mControlName}
        else
        {
       $value = $content.split("=")[1]
       }
        $mPropertiesArr+= AddProperty $entry $value
}
}
} #>

 
    $mElementsObj = New-Object PSCustomObject 
    $mElementsObj |Add-Member -Name 'Name' -MemberType NoteProperty -Value $mControlName  
    $mElementsObj |Add-Member -Name 'Type' -MemberType NoteProperty -Value ($a)
    $mElementsObj |Add-Member -Name 'Properties' -MemberType NoteProperty -Value $mPropertiesArr 

  $Global:mFormObj.Elements = @($Global:mFormObj.Elements)
  $Global:mFormObj.Elements += $mElementsObj

    renewGrids 
 
    repaintForm 
 
} 
 
function AddControl ($mControl) { 
    
 
    $mReturnControl = $null 
 
    $ctrol = $mControl.Type | Out-String 
    
    $ctrol = $ctrol.trim()
    
    switch($ctrol) {
        
        "StatusStrip" {
            $mReturnControl = New-Object System.Windows.Forms.$ctrol
    $mReturnControl.Name = $mControl.Name
    Return $mReturnControl
    }

"ToolStrip"{


#--------                 
                  
                     $oolbuttons = New-Object System.Windows.Forms.ToolStrip
                     $oolbuttons.Name = $mControl.Name
                     $oolbuttons.Text = $mControl.Name
                     foreach ($mProperty in $mControl.Properties){
                     foreach ($split in $mProperty.Value.split(",")) {
                         if ($split -ne "-") {
                             $item = new-object System.Windows.Forms.ToolStripButton
                             $isplit = $split.split("|")
                             $item.name = $isplit[0]
                            if ($(substr $isplit[1] 0 2) -eq 'ht') {
                                $item.image = $(streamimage $isplit[1])
                            }
                            else {
                                $item.image = $(fileimage $isplit[1])
                            }
                             $item.text = $isplit[2]
                             #  $item.Add_Click({&toolstripitemclick $this})
                         }
                         else {
                             $item = new-object System.Windows.Forms.ToolStripSeparator
                             $item.name = $split
                             $item.text = $split                 
                         }                       
                         $oolbuttons.Items.Add($item) | Out-Null                    
                     }}
                     #    $b.Controls.Add($toolbuttons)
                          return $oolbuttons
#--------


}
        
        default{
    
          if ($ctrol -eq "MenuStrip")
        
    {

     
     if ($global:designribbon -eq $false){
         $global:designribbon = $true
         $global:designribbonctrl = New-Object System.Windows.Forms.$ctrol
        
    }
$enutitle = new-object System.Windows.Forms.ToolStripMenuItem
                                          $enutitle.Name = $mControl.Name
                     $enutitle.Text = $mControl.Name
                     $global:designribbonctrl.Items.add($enutitle) | Out-Null

        foreach ($mProperty in $mControl.Properties){
            
        #    write-host $mProperty.Name
            

                     

                  #   write-host $mProperty.Value
                     
                     foreach ($split in $mProperty.Value.split(",")) {
                     
                        if ($split -ne "-") {
                             $innersplit = $split.split("|")
                             $split = $innersplit[0]
                             $item = new-object System.Windows.Forms.ToolStripMenuItem
                             if ($innersplit[2]) {
                                if ($(substr $innersplit[2] 0 2) -eq 'ht') {
                                    $item.image = $(streamimage $innersplit[2])
                                }
                                else {
                                $item.image = $(fileimage $innersplit[2])
                                }
                             }
                             if ($innersplit[1]) {
                                 $item.ShortCutKeys = $innersplit[1]
                                 $item.ShowShortCutKeys = $true
                             }
                             $item.name = $split
                             $item.text = $split
                             #      $item.Add_Click({
                                 #       &menuitemclick $this
                             # })
                         } 
                         else {
                             $item = new-object System.Windows.Forms.ToolStripSeparator
                             $item.name = $split
                             $item.text = $split                 
                         }                       
                         $enutitle.DropDownItems.Add($item) | Out-Null             
            
            
        }
                     
                     
        
             }
                 
                  Return $global:designribbonctrl
        
    # $mFormGroupBox.controls.add((AddControl $dummy)) 
    }
    
    else
    {

    $mReturnControl = New-Object System.Windows.Forms.$ctrol

 
    $mReturnControl.Name = $mControl.Name 
 
    $mSizeX=$null 
    $mSizeY=$null 
 
    foreach ($mProperty in $mControl.Properties){ 
 
       switch ($mProperty.Name){ 
#            'Top'   {$mReturnControl.Top=$mProperty.Value} 
#            'Left'  {$mReturnControl.Left=$mProperty.Value}  
            'Width' {$mSizeX=$mProperty.Value} 
            'Height' {$mSizeY=$mProperty.Value} 
#             'Text'  {$mReturnControl.Text=$mProperty.Value}

'AccessibilityObject' {}
'CanFocus' {}
'CanSelect' {}
'CompanyName' {}
'Container' {}
'ContainsFocus' {}
'Controls' {}
'Created' {}
'DataBindings' {}
'DeviceDpi' {}
'DisplayRectangle' {}
'Disposing' {}
'Focused' {}
'Handle' {}
'HasChildren' {}
'InvokeRequired' {}
'IsDisposed' {}
'IsHandleCreated' {}
'IsMirrored' {}
'LayoutEngine' {}
'PreferredHeight' {}
'PreferredSize' {}
'ProductName' {}
'ProductVersion' {}
'RecreatingHandle' {}
'Right' {}
'AccessibleName' {}
'AccessibleDefaultActionDescription' {}
'AccessibleDescription' {}
'AccessibleRole' {}
'ImeMode' {}
'IsAccessible' {}
'Location' {}
'Name' {}
'Parent' {}
'Region' {}
'Site' {}
'WindowTarget' {}

            default{ 
            $prop = $mProperty.Name
 $val = $mProperty.Value
 
# $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
# $attributeCollection = [System.ComponentModel.TypeDescriptor]::GetProperties($mReturnControl)[$prop].Attributes
 
 #[System.ComponentModel.TypeDescriptor]::GetProperties($mReturnControl)[$prop].Attributes | get-member | out-string

#$cheese = $mProperty | Get-Member -MemberType Property -Static | out-file c:\temp\test.txt


 
  if ($mProperty.value -ne $null){
  $mReturnControl.$prop = $val}
  
  <#
  else
 {
        if ($mReturnControl -ne $null){
      $mProperty.value = $mReturnControl.$prop}
 
 }
    #>
 
 }
 

 }
 
    } 
 
    $mReturnControl.Size = New-Object System.Drawing.Size($mSizeX,$mSizeY) 
    $mReturnControl.Add_MouseDown({MouseDown}) 
    $mReturnControl.Add_MouseMove({MouseMove ($mControl.Name)}) 
    $mReturnControl.Add_MouseUP({MouseUP})
   
   ######THIS IS A GOOD SPOT TO BOUNCE BACK PROPERTIES INTO LIST##### 
   

    Return $mReturnControl 
}
}
}
 
} 
 
function PropertiesEndEdit{ 
 
    foreach ($mProperty in $Global:mFormObj.Elements[$mElemetnsGrid.CurrentRow.Index].Properties){ 
 
        if ($mProperty.Name -eq $mPropertiesGrid.currentrow.Cells[0].FormattedValue){ 
 
            $mProperty.Value = $mPropertiesGrid.currentrow.Cells[1].FormattedValue 
 
        } 
 
    } 
 
    repaintForm 
 
} 
 
 
Function repaintForm { 

    $FormPropertiesGrid.Columns[0].Width = '140'
    $FormPropertiesGrid.Columns[1].Width = '140'

 $global:designribbon = $false
    
    $mFormGroupBox.controls.clear() 
    
    # $mFormObj.Elements | Export-Clixml c:\temp\ele.xml
    
    Foreach ($mElement in $mFormObj.Elements){ 
    
    # write-host $mElement | Get-member
 
      $mFormGroupBox.controls.add((AddControl $mElement)) 
               
    }

foreach ($row in $FormPropertiesGrid.Rows)
{
if ($row.Cells[1].Value -ne "") {
 $mFormGroupBox.($row.Cells[0].Value)=($row.Cells[1].Value)}
 if ($row.Cells[1].Value.toLower() -eq '$false') {
 $mFormGroupBox.($row.Cells[0].Value)=$false}
}   
 
}

 
Function EditFormSize ($x,$y){ 
 
    $Global:mFormObj.SizeX = $X 
    $Global:mFormObj.SizeY = $Y 
 
    repaintForm 
 
} 
 
 
function ExportForm {
    $mFormObj  
    $mExportString = ''
		$scaleString = ''
	
	if  ($scaleCheck.Checked -eq $True)
	{
	
        $scaleString+= 'info $null 2>$null
		$vscreen = [System.Windows.Forms.SystemInformation]::VirtualScreen.height
if ((get-host).version.major -eq 5) {
[xml]$xml = @"
            <Window
                    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
                    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
            </Window>
"@
$dum = (New-Object System.Xml.XmlNodeReader $xml)
$win = [Windows.Markup.XamlReader]::Load($dum)
}

$screen = [System.Windows.Forms.SystemInformation]::VirtualScreen.height

$global:ctscale = ($screen/$vscreen)
 
'
	}
    $mFooterString = ''
    $mFooterString2 = ''
    $ms = $false
    $ts = $false
	$formexport+=$mFormXTextBox2.Text+' = dialog load '+$(chr 34)+$global:openform+$(chr 34)+'
	'
    $mExportString+= $mFormXTextBox2.Text+' = dialog create "'+$mFormGroupBox.Text+'" 0 0 '+$mFormGroupBox.Width+' '+$mFormGroupBox.Height+'
    ' 
    
    foreach ($row in $FormPropertiesGrid.Rows)
{
if ($row.Cells[1].Value -ne $null){
	if ($row.Cells[1].Value -ne "") 
		{
	switch ($row.Cells[0].Value)
	{
		"height"{}
		"width"{}
		"Text"{}
		default{$mExportString+='dialog property '+$mFormXTextBox2.Text+' '+($row.Cells[0].Value) +' "'+($row.Cells[1].Value)+'"
' 		}
	}
}}}
    
    foreach ($mElement in $mFormObj.Elements){ 
	$formexport+='$'+$mElement.Name+' = dialog element '+$mFormXTextBox2.Text+' '+$mElement.Name+'
	'
        switch($mElement.Type){
            "ToolStrip" { $mExportString+='$'+$mElement.Name+' = dialog add '+$mFormXTextBox2.Text+' '+$mElement.Type }
            default {$mExportString+='$'+$mElement.Name+' = dialog add '+$mFormXTextBox2.Text+' '+$mElement.Type}
        }

        switch ($mElement.Type){
            "ToolStrip" {
                if ($ts -eq $false) {
                $ts = $true
                $mFooterString2 = '
function global:toolstripitemclick ($name) {
    switch (dlgname $name) {'
                }
               
                $mExportString+=" $(chr 34)"
                foreach ($mProperty in $mElement.Properties) {
                    if ($mProperty.Value -ne $null)# -and $mProperty.Value -ne "") 
                    {
                        $mExportString+=$mProperty.Value+','
                        $fsplit = $mProperty.Value.split("|")
                        if ($fsplit[0] -ne "-") {
                        $mFooterString2+= "
        $(chr 34)$($fsplit[0])$(chr 34){

        }"
                        }
                    }
                }
                $mExportString = $(substr $mExportString 0 ($mExportString.length -1))
                $mExportString+=$mProperty.Value+(chr 34)+'
                '
            }
           
            "MenuStrip" {
                if ($ms -eq $false) {
                    $ms = $true
                    $mFooterString = '
function global:menuitemclick ($menu) {
    switch (dlgname $menu) {'
                }
                $mExportString+=" $($mElement.Name) $(chr 34)"
                foreach ($mProperty in $mElement.Properties) {
                    if ($mProperty.Value -ne $null)# -and $mProperty.Value -ne "")
                    {
                        $mExportString+=$mProperty.Value+','
                        $fsplit = $mProperty.Value.split("|")
                        if ($fsplit[0] -ne "-") {
                            $mFooterString+= "
        $(chr 34)$($fsplit[0])$(chr 34){

        }"
                        }
              
                    }
                }
            $mExportString = $(substr $mExportString 0 ($mExportString.length -1))
            $mExportString+=$mProperty.Value+(chr 34)+'
            '
            }
   
        
            default{
                foreach ($mProperty in $mElement.Properties){
                        If ($mProperty.Name -eq 'Top'){ 
                            $mExportString+=' '+$mProperty.Value 
                        }
                } 
                foreach ($mProperty in $mElement.Properties){
                        If ($mProperty.Name -eq 'Left'){ 
                        $mExportString+=' '+$mProperty.Value 
                        }
                } 
                foreach ($mProperty in $mElement.Properties){
                    If ($mProperty.Name -eq 'Width'){ 
                    $mExportString+=' '+$mProperty.Value 
                    }
                } 

                foreach ($mProperty in $mElement.Properties){
                    If ($mProperty.Name -eq 'Height'){ 
                        $mExportString+=' '+$mProperty.Value 
                    }
                } 
                foreach ($mProperty in $mElement.Properties){
                    If ($mProperty.Name -eq 'Text'){ 
                    $mExportString+=' "'+$mProperty.Value+'"'
                    }
                } 
                $mPrSizeX='' 
                $mPrSizeY='' 
                foreach ($mProperty in $mElement.Properties){ 
                    switch ($mProperty.Name) {
                        Top {}
                        Left {}
                        Width {}
                        Height {}
                        Text {}
                        default { 
                            if ($mProperty.Value -ne $null){
                                $mExportString+=' 
        dialog property $'+$mElement.Name+' '+$mProperty.Name +' "'+$mProperty.Value+'"' 
                            }
                        }
                    } 
                } 
            $mExportString+='  
            ' 
            } 
        }
    }
    if ($ts -eq $true) {
    $mFooterString2+= "
    }
}
"
    }
    if ($ms -eq $true) {
$mFooterString+= "
    }
}
"
    }
    $mExportString+= $mFooterString+$mFooterString2+'dialog show '+$mFormXTextBox2.Text 
	$formexport+='
	'
    $FastTab.SelectedTab.Controls[0].InsertText("$scaleString$formexport$mExportString")
    $mFormGroupBox.Dispose()
    $eleOK = "false"
    $elements.Dispose()
    window close $(winexists "Dialog Elements")
    $mForm.Hide()
    $global:dd = "false"
} 
 

    $global:mform = dialog create "DialogShell Designer"
    $mform.controlbox = $false
if ($args[0])


{$mform.icon = (curdir)+"\..\res\icon.ico"
}
else{
    $dir = string (path $(Get-Module -ListAvailable vds).path)
    $mform.icon = "$dir\res\icon.ico"
}
$mForm.AutoSize = $true 

#------not sure why I'm hanging on to this.-------------
$mControlType = New-Object System.Windows.Forms.ComboBoX 
$mControlType.Anchor = 'Left,Top' 
$mControlType.Size = New-Object System.Drawing.Size(100,23) 
$mControlType.Left = 5 
$mControlType.Top = 5 

$controls = 'BindingNavigator
BindingSource
Button
CheckBox
CheckedListBox
ComboBox
DataGrid
DataGridView
DateTimePicker
DomainUpDown
ErrorProvider
FlowLayoutPanel
GroupBox
HScrollBar
VScrollBar
Label
LinkLabel
ListBox
MaskedTextBox
MenuStrip
MonthCalendar
NotifyIcon
NumericUpDown
Panel
PictureBox
ProgressBar
RadioButton
RichTextBox
SplitContainer
StatusStrip
TabControl
TabLayoutControlPanel
TextBox
ToolStrip
ToolStripPanel
ToolStripProgessBar
ToolStripStatusLabel
ToolTip
TrackBar
TreeView
WebBrowser'

$mControlType.items.addrange($controls.Split([char][byte]10))

$mControlType.SelectedIndex = 2

#$mForm.Controls.Add($mControlType) 
#$mControlType.Visible = $false

$mAddButton = New-Object System.Windows.Forms.Button 
$mAddButton.Text = 'Add' 
$mAddButton.Left = 110 
$mAddButton.Top = 5 
$mAddButton.Size = New-Object System.Drawing.Size(50,23) 
$mAddButton.Add_Click({AddElement}) 

#$mForm.Controls.Add($mAddButton) 
 
$scaleCheck = dialog add $mform CheckBox 35 445 200 20 "Fix Scaling for HDR"
 
$mFormLabel = dialog add $mform label 5 5 30 25 'Title:'
$mFormLabel.TextAlign='MiddleRight' 
 
$mFormXTextBox = dialog add $mform textbox 5 50 90 100 'Form'
$mFormXTextBox.add_KeyUp({$mFormGroupBox.Text = $mFormXTextBox.text})

$mFormLabel2 = dialog add $mform label 5 100 80 23 'Name:' 
$mFormLabel2.TextAlign='MiddleRight' 
 
$mFormXTextBox2 = dialog add $mform textbox 5 190 90 ' ' '$Form'
$mFormXTextBox2.add_KeyUp({$mFormGroupBox.Text = $mFormXTextBox.text})
 
$mElemetnsGrid = dialog add $mform datagridview 33 5 300 600

$mElemetnsGrid.RowHeadersVisible =$false 
$mElementsGrid.Font = ",8"
$mElemetnsGrid.Add_CellContentClick({
ElementsChanged}) 

$mElemetnsGrid.Add_Click({
   renewGrids $mElemetnsGrid.SelectedCells.value | out-string
ElementsChanged}) 

$mElemetnsGrid.Add_CellEndEdit({ElementsEndEdit}) 
 
$tabcontrol = dialog add $mform tabcontrol 33 335 310 600
$tabpage1 = dialog add $tabcontrol tabpage
dialog set $tabpage1 "Controls"
$tabpage2 = dialog add $tabcontrol tabpage
dialog set $tabpage2 "Form"

$mPropertiesGrid = dialog add $tabpage1 datagridview 0 0 300 575
$mPropertiesGrid.ColumnHeadersVisible=$true 
$mPropertiesGrid.RowHeadersVisible =$false 

$FormPropertiesGrid = dialog add $tabpage2 datagridview 0 0 300 575
$FormPropertiesGrid.ColumnHeadersVisible=$true 
$FormPropertiesGrid.ColumnCount = 2
$FormPropertiesGrid.RowHeadersVisible =$false
$FormPropertiesGrid.Columns[0].Name = "Property"
$FormPropertiesGrid.Columns[1].Name = "Value"

    $FormPropertiesGrid.Columns[0].Width = '140'
    $FormPropertiesGrid.Columns[1].Width = '140'

$FormPropertiesGrid.Add_CellEndEdit({
# write-host $FormPropertiesGrid.CurrentRow | out-string

if ($FormPropertiesGrid.Rows[$FormPropertiesGrid.CurrentRow.index].Cells[1].Value -ne "")
{
$prop = $FormPropertiesGrid.Rows[$FormPropertiesGrid.CurrentRow.index].Cells[0].Value
$mFormGroupBox.$prop = $FormPropertiesGrid.Rows[$FormPropertiesGrid.CurrentRow.index].Cells[1].Value
}

if ($FormPropertiesGrid.Rows[$FormPropertiesGrid.CurrentRow.index].Cells[1].Value.toLower() -eq '$false')
{$prop = $FormPropertiesGrid.Rows[$FormPropertiesGrid.CurrentRow.index].Cells[0].Value
$mFormGroupBox.$prop = $False}


})

$mPropertiesGrid.Add_CellEndEdit({PropertiesEndEdit})
#$mPropertiesGrid.Add_CellContentClick({info "click"}) 
 
$mDeleteButton = dialog add $mform button 638 5 300 33 'Delete'
$mDeleteButton.Add_Click({DeleteElement}) 

$mFormList = dialog add $mform ComboBox 10 335 300 30
dialog property $mFormList DropDownStyle DropDownList

$a = $(sendmsg $mFormList.handle 352 480 0)

$mFormList.add_SelectedValueChanged({
$global:openform = $mFormList.selecteditem
            $mFormObj.Elements = Import-Clixml $global:openform
            inifile open $global:openform
            $mFormXTextBox2.Text = $(iniread Form Object)
            $mFormXTextBox.Text = $(iniread Form Text)
		#	$mFormGroupBox.Top = $(iniread Form Top)
		#	$mFormGroupBox.Left = $(iniread Form Left)
            $mFormGroupBox.Height = $(iniread Form Height)
            $mFormGroupBox.Width = $(iniread Form Width)
            $mFormGroupBox.Text = $mFormXTextBox.text
            
            $FormPropertiesGrid.rows.Clear()
            
        
            
$FormPropertiesGrid.Rows.Add("AcceptButton",$(iniread Form AcceptButton))
$FormPropertiesGrid.Rows.Add("ActiveControl",$(iniread Form ActiveControl))
$FormPropertiesGrid.Rows.Add("ActiveMdiChild",$(iniread Form ActiveMdiChild))
$FormPropertiesGrid.Rows.Add("AllowDrop",$(iniread Form AllowDrop))
$FormPropertiesGrid.Rows.Add("AllowTransparency",$(iniread Form AllowTransparency))
$FormPropertiesGrid.Rows.Add("Anchor",$(iniread Form Anchor))
$FormPropertiesGrid.Rows.Add("AutoScale",$(iniread Form AutoScale))
$FormPropertiesGrid.Rows.Add("AutoScaleBaseSize",$(iniread Form AutoScaleBaseSize))
$FormPropertiesGrid.Rows.Add("AutoScaleDimensions",$(iniread Form AutoScaleDimensions))
$FormPropertiesGrid.Rows.Add("AutoScaleMode",$(iniread Form AutoScaleMode))
$FormPropertiesGrid.Rows.Add("AutoScroll",$(iniread Form AutoScroll))
$FormPropertiesGrid.Rows.Add("AutoScrollMargin",$(iniread Form AutoScrollMargin))
$FormPropertiesGrid.Rows.Add("AutoScrollMinSize",$(iniread Form AutoScrollMinSize))
$FormPropertiesGrid.Rows.Add("AutoScrollOffset",$(iniread Form AutoScrollOffset))
$FormPropertiesGrid.Rows.Add("AutoScrollPosition",$(iniread Form AutoScrollPosition))
$FormPropertiesGrid.Rows.Add("AutoSize",$(iniread Form AutoSize))
$FormPropertiesGrid.Rows.Add("AutoSizeMode",$(iniread Form AutoSizeMode))
$FormPropertiesGrid.Rows.Add("AutoValidate",$(iniread Form AutoValidate))
$FormPropertiesGrid.Rows.Add("BackColor",$(iniread Form BackColor))
$FormPropertiesGrid.Rows.Add("BackgroundImage",$(iniread Form BackgroundImage))
$FormPropertiesGrid.Rows.Add("BackgroundImageLayout",$(iniread Form BackgroundImageLayout))
$FormPropertiesGrid.Rows.Add("BindingContext",$(iniread Form BindingContext))
$FormPropertiesGrid.Rows.Add("Bottom",$(iniread Form Bottom))
$FormPropertiesGrid.Rows.Add("Bounds",$(iniread Form Bounds))
$FormPropertiesGrid.Rows.Add("CancelButton",$(iniread Form CancelButton))
$FormPropertiesGrid.Rows.Add("Capture",$(iniread Form Capture))
$FormPropertiesGrid.Rows.Add("CausesValidation",$(iniread Form CausesValidation))
$FormPropertiesGrid.Rows.Add("ClientRectangle",$(iniread Form ClientRectangle))
$FormPropertiesGrid.Rows.Add("ClientSize",$(iniread Form ClientSize))
$FormPropertiesGrid.Rows.Add("ContextMenu",$(iniread Form ContextMenu))
$FormPropertiesGrid.Rows.Add("ContextMenuStrip",$(iniread Form ContextMenuStrip))
$FormPropertiesGrid.Rows.Add("ControlBox",$(iniread Form ControlBox))
$FormPropertiesGrid.Rows.Add("CurrentAutoScaleDimensions",$(iniread Form CurrentAutoScaleDimensions))
$FormPropertiesGrid.Rows.Add("Cursor",$(iniread Form Cursor))
$FormPropertiesGrid.Rows.Add("DesktopBounds",$(iniread Form DesktopBounds))
$FormPropertiesGrid.Rows.Add("DesktopLocation",$(iniread Form DesktopLocation))
$FormPropertiesGrid.Rows.Add("DialogResult",$(iniread Form DialogResult))
$FormPropertiesGrid.Rows.Add("Dock",$(iniread Form Dock))
$FormPropertiesGrid.Rows.Add("DockPadding",$(iniread Form DockPadding))
$FormPropertiesGrid.Rows.Add("Enabled",$(iniread Form Enabled))
$FormPropertiesGrid.Rows.Add("Font",$(iniread Form Font))
$FormPropertiesGrid.Rows.Add("ForeColor",$(iniread Form ForeColor))
$FormPropertiesGrid.Rows.Add("FormBorderStyle",$(iniread Form FormBorderStyle))
$FormPropertiesGrid.Rows.Add("Height",$(iniread Form Height))
$FormPropertiesGrid.Rows.Add("HelpButton",$(iniread Form HelpButton))
$FormPropertiesGrid.Rows.Add("HorizontalScroll",$(iniread Form HorizontalScroll))
$FormPropertiesGrid.Rows.Add("Icon",$(iniread Form Icon))
$FormPropertiesGrid.Rows.Add("IsMdiChild",$(iniread Form IsMdiChild))
$FormPropertiesGrid.Rows.Add("IsMdiContainer",$(iniread Form IsMdiContainer))
$FormPropertiesGrid.Rows.Add("IsRestrictedWindow",$(iniread Form IsRestrictedWindow))
$FormPropertiesGrid.Rows.Add("KeyPreview",$(iniread Form KeyPreview))
$FormPropertiesGrid.Rows.Add("Left",$(iniread Form Left))
$FormPropertiesGrid.Rows.Add("MainMenuStrip",$(iniread Form MainMenuStrip))
$FormPropertiesGrid.Rows.Add("Margin",$(iniread Form Margin))
$FormPropertiesGrid.Rows.Add("MaximizeBox",$(iniread Form MaximizeBox))
$FormPropertiesGrid.Rows.Add("MaximumSize",$(iniread Form MaximumSize))
$FormPropertiesGrid.Rows.Add("MdiChildren",$(iniread Form MdiChildren))
$FormPropertiesGrid.Rows.Add("MdiParent",$(iniread Form MdiParent))
$FormPropertiesGrid.Rows.Add("Menu",$(iniread Form Menu))
$FormPropertiesGrid.Rows.Add("MergedMenu",$(iniread Form MergedMenu))
$FormPropertiesGrid.Rows.Add("MinimizeBox",$(iniread Form MinimizeBox))
$FormPropertiesGrid.Rows.Add("MinimumSize",$(iniread Form MinimumSize))
$FormPropertiesGrid.Rows.Add("Modal",$(iniread Form Modal))
$FormPropertiesGrid.Rows.Add("Opacity",$(iniread Form Opacity))
$FormPropertiesGrid.Rows.Add("OwnedForms",$(iniread Form OwnedForms))
$FormPropertiesGrid.Rows.Add("Owner",$(iniread Form Owner))
$FormPropertiesGrid.Rows.Add("Padding",$(iniread Form Padding))
$FormPropertiesGrid.Rows.Add("ParentForm",$(iniread Form ParentForm))
$FormPropertiesGrid.Rows.Add("RestoreBounds",$(iniread Form RestoreBounds))
$FormPropertiesGrid.Rows.Add("RightToLeft",$(iniread Form RightToLeft))
$FormPropertiesGrid.Rows.Add("RightToLeftLayout",$(iniread Form RightToLeftLayout))
$FormPropertiesGrid.Rows.Add("ShowIcon",$(iniread Form ShowIcon))
$FormPropertiesGrid.Rows.Add("ShowInTaskbar",$(iniread Form ShowInTaskbar))
$FormPropertiesGrid.Rows.Add("Size",$(iniread Form Size))
$FormPropertiesGrid.Rows.Add("SizeGripStyle",$(iniread Form SizeGripStyle))
$FormPropertiesGrid.Rows.Add("StartPosition",$(iniread Form StartPosition))
$FormPropertiesGrid.Rows.Add("TabIndex",$(iniread Form TabIndex))
$FormPropertiesGrid.Rows.Add("TabStop",$(iniread Form TabStop))
$FormPropertiesGrid.Rows.Add("Tag",$(iniread Form Tag))
$FormPropertiesGrid.Rows.Add("Text",$(iniread Form Text))
$FormPropertiesGrid.Rows.Add("Top",$(iniread Form Top))
$FormPropertiesGrid.Rows.Add("TopLevel",$(iniread Form TopLevel))
$FormPropertiesGrid.Rows.Add("TopLevelControl",$(iniread Form TopLevelControl))
$FormPropertiesGrid.Rows.Add("TopMost",$(iniread Form TopMost))
$FormPropertiesGrid.Rows.Add("TransparencyKey",$(iniread Form TransparencyKey))
$FormPropertiesGrid.Rows.Add("UseWaitCursor",$(iniread Form UseWaitCursor))
$FormPropertiesGrid.Rows.Add("VerticalScroll",$(iniread Form VerticalScroll))
$FormPropertiesGrid.Rows.Add("Visible",$(iniread Form Visible))
$FormPropertiesGrid.Rows.Add("Width",$(iniread Form Width))
$FormPropertiesGrid.Rows.Add("WindowState",$(iniread Form WindowState))

            
            # $mFormObj.Elements = Import-Csv $openform
        #   $mFormObj.Elements = Get-Content -Path $openform | ConvertFrom-Json
               renewGrids #$mElemetnsGrid.SelectedCells.value | out-string
ElementsChanged
repaintForm
            


})


          #  $content = get-content $c -skip 1
          #  $b.items.addrange($content)
 
$mExportButton = dialog add $mform button 638 335 150 33 'Print Form'

$mNewButton = dialog add $mform button 638 485 150 33 'New Form'

$mCancelButton = dialog add $mform button (638+35) 5 300 33 'Cancel'

$mSaveButton = dialog add $mform button (638+35) 335 150 33 'Save Form'
$mSaveButton.add_Click({
$saveform = (savedlg "DialogShell Form|*.dsform")
    if ($saveForm) {
		$global:openform = $saveform
#   $mFormObj.Elements | ConvertTo-Json -depth 1- | Set-Content -Path $saveform 
         $mFormObj.Elements | Export-Clixml $saveForm 
                         $find = $mFormList.FindString($saveForm)
                 if ($find -eq -1){
                 $mFormList.items.Add($saveForm)}
         list clear $mAssignList
         list assign $mAssignList $mFormList
                 
         Add-Content $saveForm "<!--
[Form]
Object=$($mFormXTextBox2.Text)
Text=$($mFormXTextBox.Text)
Height=$($global:mfgby)
Width=$($global:mfgbx)"

foreach ($row in $FormPropertiesGrid.Rows)
{
Add-Content $saveForm "$($row.Cells[0].Value)=$($row.Cells[1].Value)"
}
Add-Content $saveForm "-->"
        
        # $mForm.Obj.Elements | export-csv $saveform -NoTypeInformation
    }
})
$mOpenButton = dialog add $mform button (638+35) 485 150 33 'Open Form'
$mOpenButton.add_Click({
    $global:openform = filedlg("DialogShell Form|*.dsform")
        if ($global:openform){
                 $find = $mFormList.FindString($global:openform)
                 if ($find -eq -1){
                 $mFormList.items.Add($global:openform)}
                list clear $mAssignList
                list assign $mAssignList $mFormList
            $mFormObj.Elements = Import-Clixml $global:openform
            inifile open $global:openform
            $mFormXTextBox2.Text = $(iniread Form Object)
            $mFormXTextBox.Text = $(iniread Form Text)
            $mFormGroupBox.Height = $(iniread Form Height)
            $mFormGroupBox.Width = $(iniread Form Width)
            $mFormGroupBox.Text = $mFormXTextBox.text
            
            $FormPropertiesGrid.rows.Clear()
            
        
            
$FormPropertiesGrid.Rows.Add("AcceptButton",$(iniread Form AcceptButton))
$FormPropertiesGrid.Rows.Add("ActiveControl",$(iniread Form ActiveControl))
$FormPropertiesGrid.Rows.Add("ActiveMdiChild",$(iniread Form ActiveMdiChild))
$FormPropertiesGrid.Rows.Add("AllowDrop",$(iniread Form AllowDrop))
$FormPropertiesGrid.Rows.Add("AllowTransparency",$(iniread Form AllowTransparency))
$FormPropertiesGrid.Rows.Add("Anchor",$(iniread Form Anchor))
$FormPropertiesGrid.Rows.Add("AutoScale",$(iniread Form AutoScale))
$FormPropertiesGrid.Rows.Add("AutoScaleBaseSize",$(iniread Form AutoScaleBaseSize))
$FormPropertiesGrid.Rows.Add("AutoScaleDimensions",$(iniread Form AutoScaleDimensions))
$FormPropertiesGrid.Rows.Add("AutoScaleMode",$(iniread Form AutoScaleMode))
$FormPropertiesGrid.Rows.Add("AutoScroll",$(iniread Form AutoScroll))
$FormPropertiesGrid.Rows.Add("AutoScrollMargin",$(iniread Form AutoScrollMargin))
$FormPropertiesGrid.Rows.Add("AutoScrollMinSize",$(iniread Form AutoScrollMinSize))
$FormPropertiesGrid.Rows.Add("AutoScrollOffset",$(iniread Form AutoScrollOffset))
$FormPropertiesGrid.Rows.Add("AutoScrollPosition",$(iniread Form AutoScrollPosition))
$FormPropertiesGrid.Rows.Add("AutoSize",$(iniread Form AutoSize))
$FormPropertiesGrid.Rows.Add("AutoSizeMode",$(iniread Form AutoSizeMode))
$FormPropertiesGrid.Rows.Add("AutoValidate",$(iniread Form AutoValidate))
$FormPropertiesGrid.Rows.Add("BackColor",$(iniread Form BackColor))
$FormPropertiesGrid.Rows.Add("BackgroundImage",$(iniread Form BackgroundImage))
$FormPropertiesGrid.Rows.Add("BackgroundImageLayout",$(iniread Form BackgroundImageLayout))
$FormPropertiesGrid.Rows.Add("BindingContext",$(iniread Form BindingContext))
$FormPropertiesGrid.Rows.Add("Bottom",$(iniread Form Bottom))
$FormPropertiesGrid.Rows.Add("Bounds",$(iniread Form Bounds))
$FormPropertiesGrid.Rows.Add("CancelButton",$(iniread Form CancelButton))
$FormPropertiesGrid.Rows.Add("Capture",$(iniread Form Capture))
$FormPropertiesGrid.Rows.Add("CausesValidation",$(iniread Form CausesValidation))
$FormPropertiesGrid.Rows.Add("ClientRectangle",$(iniread Form ClientRectangle))
$FormPropertiesGrid.Rows.Add("ClientSize",$(iniread Form ClientSize))
$FormPropertiesGrid.Rows.Add("ContextMenu",$(iniread Form ContextMenu))
$FormPropertiesGrid.Rows.Add("ContextMenuStrip",$(iniread Form ContextMenuStrip))
$FormPropertiesGrid.Rows.Add("ControlBox",$(iniread Form ControlBox))
$FormPropertiesGrid.Rows.Add("CurrentAutoScaleDimensions",$(iniread Form CurrentAutoScaleDimensions))
$FormPropertiesGrid.Rows.Add("Cursor",$(iniread Form Cursor))
$FormPropertiesGrid.Rows.Add("DesktopBounds",$(iniread Form DesktopBounds))
$FormPropertiesGrid.Rows.Add("DesktopLocation",$(iniread Form DesktopLocation))
$FormPropertiesGrid.Rows.Add("DialogResult",$(iniread Form DialogResult))
$FormPropertiesGrid.Rows.Add("Dock",$(iniread Form Dock))
$FormPropertiesGrid.Rows.Add("DockPadding",$(iniread Form DockPadding))
$FormPropertiesGrid.Rows.Add("Enabled",$(iniread Form Enabled))
$FormPropertiesGrid.Rows.Add("Font",$(iniread Form Font))
$FormPropertiesGrid.Rows.Add("ForeColor",$(iniread Form ForeColor))
$FormPropertiesGrid.Rows.Add("FormBorderStyle",$(iniread Form FormBorderStyle))
$FormPropertiesGrid.Rows.Add("Height",$(iniread Form Height))
$FormPropertiesGrid.Rows.Add("HelpButton",$(iniread Form HelpButton))
$FormPropertiesGrid.Rows.Add("HorizontalScroll",$(iniread Form HorizontalScroll))
$FormPropertiesGrid.Rows.Add("Icon",$(iniread Form Icon))
$FormPropertiesGrid.Rows.Add("IsMdiChild",$(iniread Form IsMdiChild))
$FormPropertiesGrid.Rows.Add("IsMdiContainer",$(iniread Form IsMdiContainer))
$FormPropertiesGrid.Rows.Add("IsRestrictedWindow",$(iniread Form IsRestrictedWindow))
$FormPropertiesGrid.Rows.Add("KeyPreview",$(iniread Form KeyPreview))
$FormPropertiesGrid.Rows.Add("Left",$(iniread Form Left))
$FormPropertiesGrid.Rows.Add("MainMenuStrip",$(iniread Form MainMenuStrip))
$FormPropertiesGrid.Rows.Add("Margin",$(iniread Form Margin))
$FormPropertiesGrid.Rows.Add("MaximizeBox",$(iniread Form MaximizeBox))
$FormPropertiesGrid.Rows.Add("MaximumSize",$(iniread Form MaximumSize))
$FormPropertiesGrid.Rows.Add("MdiChildren",$(iniread Form MdiChildren))
$FormPropertiesGrid.Rows.Add("MdiParent",$(iniread Form MdiParent))
$FormPropertiesGrid.Rows.Add("Menu",$(iniread Form Menu))
$FormPropertiesGrid.Rows.Add("MergedMenu",$(iniread Form MergedMenu))
$FormPropertiesGrid.Rows.Add("MinimizeBox",$(iniread Form MinimizeBox))
$FormPropertiesGrid.Rows.Add("MinimumSize",$(iniread Form MinimumSize))
$FormPropertiesGrid.Rows.Add("Modal",$(iniread Form Modal))
$FormPropertiesGrid.Rows.Add("Opacity",$(iniread Form Opacity))
$FormPropertiesGrid.Rows.Add("OwnedForms",$(iniread Form OwnedForms))
$FormPropertiesGrid.Rows.Add("Owner",$(iniread Form Owner))
$FormPropertiesGrid.Rows.Add("Padding",$(iniread Form Padding))
$FormPropertiesGrid.Rows.Add("ParentForm",$(iniread Form ParentForm))
$FormPropertiesGrid.Rows.Add("RestoreBounds",$(iniread Form RestoreBounds))
$FormPropertiesGrid.Rows.Add("RightToLeft",$(iniread Form RightToLeft))
$FormPropertiesGrid.Rows.Add("RightToLeftLayout",$(iniread Form RightToLeftLayout))
$FormPropertiesGrid.Rows.Add("ShowIcon",$(iniread Form ShowIcon))
$FormPropertiesGrid.Rows.Add("ShowInTaskbar",$(iniread Form ShowInTaskbar))
$FormPropertiesGrid.Rows.Add("Size",$(iniread Form Size))
$FormPropertiesGrid.Rows.Add("SizeGripStyle",$(iniread Form SizeGripStyle))
$FormPropertiesGrid.Rows.Add("StartPosition",$(iniread Form StartPosition))
$FormPropertiesGrid.Rows.Add("TabIndex",$(iniread Form TabIndex))
$FormPropertiesGrid.Rows.Add("TabStop",$(iniread Form TabStop))
$FormPropertiesGrid.Rows.Add("Tag",$(iniread Form Tag))
$FormPropertiesGrid.Rows.Add("Text",$(iniread Form Text))
$FormPropertiesGrid.Rows.Add("Top",$(iniread Form Top))
$FormPropertiesGrid.Rows.Add("TopLevel",$(iniread Form TopLevel))
$FormPropertiesGrid.Rows.Add("TopLevelControl",$(iniread Form TopLevelControl))
$FormPropertiesGrid.Rows.Add("TopMost",$(iniread Form TopMost))
$FormPropertiesGrid.Rows.Add("TransparencyKey",$(iniread Form TransparencyKey))
$FormPropertiesGrid.Rows.Add("UseWaitCursor",$(iniread Form UseWaitCursor))
$FormPropertiesGrid.Rows.Add("VerticalScroll",$(iniread Form VerticalScroll))
$FormPropertiesGrid.Rows.Add("Visible",$(iniread Form Visible))
$FormPropertiesGrid.Rows.Add("Width",$(iniread Form Width))
$FormPropertiesGrid.Rows.Add("WindowState",$(iniread Form WindowState))
            
            # $mFormObj.Elements = Import-Csv $openform
        #   $mFormObj.Elements = Get-Content -Path $openform | ConvertFrom-Json
               renewGrids #$mElemetnsGrid.SelectedCells.value | out-string
ElementsChanged
repaintForm
            
        }
})
 
 $mNewButton.add_Click({
$ask = $(ask "Changes will be lost. Continue to close?")
if (($ask | out-string).trim() -eq "Yes"){
$FormPropertiesGrid.Rows.Clear()
$Global:mFormObj = new-object PSCustomObject 
$Global:mFormObj | Add-Member -Name 'Elements' -MemberType NoteProperty -Value @() 
renewGrids
$mFormGroupBox.Close()
$mFormXTextBox = "Form"
$mFormXTextBox2 = '$Form'
}
})
 
$mCancelButton.add_Click({
$mFormGroupBox.Dispose()
$eleOK = "false"
$elements.Dispose()
window close $(winexists "Dialog Elements")
$mForm.Hide()
$global:dd = "false"
})

$mExportButton.Add_Click({ExportForm}) 
 
$Global:mFormObj = new-object PSCustomObject 

$Global:mFormObj | Add-Member -Name 'Elements' -MemberType NoteProperty -Value @() 

$Global:mCurFirstX =0  
$Global:mCurFirstY =0 

#$mFormObj.Elements =  Import-Clixml C:\temp\ele.xml

$mForm.add_Closed({
$mFormGroupBox.Dispose()
$eleOK = "false"
$elements.Dispose()
window close $(winexists "Dialog Elements")

})

 function DesignWindow{
$Global:mFormGroupBox = dialog create $mFormXTextBox.text 0 0 $global:mfgbx $global:mfgby
    $dir = string "$module"
    $mFormGroupBox.icon = "$dir\res\application.ico"

$mFormGroupBox.AllowDrop = $true
$mFormGroupBox.add_DragEnter({
if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
            foreach ($filename in $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop))  {
                AddElement2 $(name $filename) $filename
            }
            }
})

$mFormGroupBox.add_Resize({
$global:mfgby = $mFormGroupBox.height
$global:mfgbx = $mFormGroupBox.width
})

$mFormGroupBox.add_Closed({DesignWindow
     $global:designribbon = $false
repaintForm})


if ($FormPropertiesGrid.Rows.count -eq 1)
{

 foreach ($mProperty in ($mFormGroupBox | get-member)){ 
 if ($mProperty.membertype.toString() -eq "Property"){
       switch ($mProperty.Name){ 
<#           'Top'   {} 
            'Left'  {}  
            'Width' {} 
            'Height' {} 
             'Text'  {}
#>
'AccessibilityObject' {}
'CanFocus' {}
'CanSelect' {}
'CompanyName' {}
'Container' {}
'ContainsFocus' {}
'Controls' {}
'Created' {}
'DataBindings' {}
'DeviceDpi' {}
'DisplayRectangle' {}
'Disposing' {}
'Focused' {}
'Handle' {}
'HasChildren' {}
'InvokeRequired' {}
'IsDisposed' {}
'IsHandleCreated' {}
'IsMirrored' {}
'LayoutEngine' {}
'PreferredHeight' {}
'PreferredSize' {}
'ProductName' {}
'ProductVersion' {}
'RecreatingHandle' {}
'Right' {}
'AccessibleName' {}
'AccessibleDefaultActionDescription' {}
'AccessibleDescription' {}
'AccessibleRole' {}
'ImeMode' {}
'IsAccessible' {}
'Location' {}
'Name' {}
'Parent' {}
'Region' {}
'Site' {}
'WindowTarget' {}

            default{ 
        #   write-host $mFormGroupBox.($mProperty.name) | out-string
#$FormPropertiesGrid.Rows.Add($mProperty.Name,$mFormGroupBox.($mProperty.name))
$FormPropertiesGrid.Rows.Add($mProperty.Name,"")
}
}
}
}
}
$mFormGroupBox.Show()

$mFormGroupBox.left = 500

 

repaintForm
 [vds]::SetWindowPos($mForm.handle, -1, $(winpos $mForm.handle L), $(winpos $mForm.handle T), $(winpos $mForm.handle W), $(winpos $mForm.handle H),  0x0040)
                 [vds]::SetWindowPos($elements.handle, -1, $(winpos $elements.handle L), $(winpos $elements.handle T), $(winpos $elements.handle W), $(winpos $elements.handle H), 0x0040)
[vds]::SetWindowPos($mFormGroupBox.handle, -1, $(winpos $mFormGroupBox.handle L), $(winpos $mFormGroupBox.handle T), $(winpos $mFormGroupBox.handle W), $(winpos $mFormGroupBox.handle H), 0x0040)
}

function elementswindow{
    $global:elements = dialog create "Dialog Elements" 0 0 300 500

    $elements.icon = $mform.icon

        $mWebBrowser1 = dialog add $elements WebBrowser 0 0 300 500  
                $mWebBrowser1.Dock = "Fill"
				
				#--------------------
				    $buttonout          = "Text=Button$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.button?view=netframework-4.7.2$(cr)IconFile=$module\res\Button.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $checkboxout        = "Text=$(cr)Appearance=Normal$(cr)Threestate=$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.checkbox?view=netframework-4.7.2$(cr)IconFile=$module\res\CheckBox.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $checkedlistboxout  = "CheckOnClick=$(cr)UseTabStops=True$(cr)Multicolumn=$(cr)Selectionmode=One$(cr)Sorted=False$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.checkedlistbox?view=netframework-4.7.2$(cr)IconFile=$module\res\CheckedListBox.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $comboboxout        = "DropDownStyle=DropDown$(cr)Text=$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.combobox?view=netframework-4.7.2$(cr)IconFile=$module\res\ComboBox.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $datagridout        = "[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.datagrid?view=netframework-4.7.2$(cr)IconFile=$module\res\DataGrid.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $datagridviewout    = "[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.datagridview?view=netframework-4.7.2$(cr)IconFile=$module\res\DataGridView.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $datetimepickerout  = "Mindate=$(cr)Maxdate=$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.DateTimePicker?view=netframework-4.7.2$(cr)IconFile=$module\res\DateTimePicker.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $groupboxout        = "Text=$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.groupbox?view=netframework-4.7.2$(cr)IconFile=$module\res\GroupBox.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $hscrollbarout      = "Value=50$(cr)LargeChange=10$(cr)SmallChange=1$(cr)Minimum=0$(cr)Maximum=100$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.hscrollbar?view=netframework-4.7.2$(cr)IconFile=$module\res\HScrollBar.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $labelout           = "Text=$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.label?view=netframework-4.7.2$(cr)IconFile=$module\res\Label.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $linklabelout       = "Text=$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.linklabel?view=netframework-4.7.2$(cr)IconFile=$module\res\LinkLabel.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $listboxout         = "Sorted=$(cr)Selectionmode=One$(cr)Multicolumn=$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.listbox?view=netframework-4.7.2$(cr)IconFile=$module\res\ListBox.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $maskedtextboxout   = "Mask=00/00/0000$(cr)Text=00/00/0000$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.maskedtextbox?view=netframework-4.7.2$(cr)IconFile=$module\res\MaskedTextBox.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $menustripout       = "[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.menustrip?view=netframework-4.7.2$(cr)IconFile=$module\res\MenuStrip.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $monthcalendarout   = "Mindate=$(cr)Maxdate=$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.monthcalendar?view=netframework-4.7.2$(cr)IconFile=$module\res\MonthCalendar.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $numericupdownout   = "DecimalPlaces=0$(cr)Increment=1$(cr)Maximum=100$(cr)Minimum=0$(cr)Value=0$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.numericupdown?view=netframework-4.7.2$(cr)IconFile=$module\res\NumericUpDown.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $panel              = "BorderStyle=Fixed3D$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.panel?view=netframework-4.7.2$(cr)IconFile=$module\res\Panel.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $pictureboxout      = "BorderStyle=Fixed3D$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.picturebox?view=netframework-4.7.2$(cr)IconFile=$module\res\PictureBox.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $progressbarout     = "Minimum=0$(cr)Maximum=100$(cr)Value=0$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.progressbar?view=netframework-4.7.2$(cr)IconFile=$module\res\ProgressBar.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $radiobuttonout     = "Text=RadioButton$(cr)Checked=$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.radiobutton?view=netframework-4.7.2$(cr)IconFile=$module\res\RadioButton.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $richtextboxout     = "Text=RichTextBox$(cr)Dock=None$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.richtextbox?view=netframework-4.7.2$(cr)IconFile=$module\res\RichTextBox.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $statusstripout     = "Text=statusstrip$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.statusstrip?view=netframework-4.7.2$(cr)IconFile=$module\res\StatusStrip.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $textboxout         = "Text=Textbox$(cr)Multiline=$(cr)Maxlength=0$(cr)Wordwrap=true$(cr)Scrollbars=none$(cr)acceptstab=$(cr)acceptsreturn=$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.textbox?view=netframework-4.7.2$(cr)IconFile=$module\res\TextBox.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $toolstripout       = "Text=toolstrip$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.toolstrip?view=netframework-4.7.2$(cr)IconFile=$module\res\ToolStrip.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $trackbarout        = "Value=5$(cr)Minimum=0$(cr)Maximum=10$(cr)LargeChange=5$(cr)SmallChange=1$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.trackbar?view=netframework-4.7.2$(cr)IconFile=$module\res\TrackBar.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $treeviewout        = "[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.treeview?view=netframework-4.7.2$(cr)IconFile=$module\res\TreeView.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $vscrollbarout      = "Value=50$(cr)LargeChange=10$(cr)SmallChange=1$(cr)Minimum=0$(cr)Maximum=100$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.vscrollbar?view=netframework-4.7.2$(cr)IconFile=$module\res\VScrollBar.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $webbrowserout      = "Dock=None$(cr)Url=$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.webbrowser?view=netframework-4.7.2$(cr)IconFile=$module\res\WebBrowser.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    
					directory create "$(env temp)\elements"
					
                    $buttonout          | Out-File "$(env temp)\elements\Button.url"
                    $checkboxout        | Out-File "$(env temp)\elements\CheckBox.url"    
                    $checkedlistboxout  | Out-File "$(env temp)\elements\CheckedListBox.url"   
                    $comboboxout        | Out-File "$(env temp)\elements\ComboBox.url"
                    $datagridout        | Out-File "$(env temp)\elements\DataGrid.url"
                    $datagridviewout    | Out-File "$(env temp)\elements\DataGridView.url"
                    $datetimepickerout  | Out-File "$(env temp)\elements\DateTimePicker.url"
                    $groupboxout        | Out-File "$(env temp)\elements\GroupBox.url"
                    $hscrollbarout      | Out-File "$(env temp)\elements\HScrollBar.url"
                    $labelout           | Out-File "$(env temp)\elements\Label.url"
                    $linklabelout       | Out-File "$(env temp)\elements\LinkLabel.url"
                    $listboxout         | Out-File "$(env temp)\elements\ListBox.url"
                    $maskedtextboxout   | Out-File "$(env temp)\elements\MaskedTextBox.url"
                    $menustripout       | Out-File "$(env temp)\elements\MenuStrip.url"
                    $monthcalendarout   | Out-File "$(env temp)\elements\MonthCalendar.url"
                    $numericupdownout   | Out-File "$(env temp)\elements\NumericUpDown.url"
                    $panel              | Out-File "$(env temp)\elements\Panel.url"
                    $pictureboxout      | Out-File "$(env temp)\elements\PictureBox.url"
                    $progressbarout     | Out-File "$(env temp)\elements\ProgressBar.url"
                    $radiobuttonout     | Out-File "$(env temp)\elements\RadioButton.url"
                    $richtextboxout     | Out-File "$(env temp)\elements\RichTextBox.url"
                    $statusstripout     | Out-File "$(env temp)\elements\StatusStrip.url"
                    $textboxout         | Out-File "$(env temp)\elements\TextBox.url"
                    $toolstripout       | Out-File "$(env temp)\elements\ToolStrip.url"
                    $trackbarout        | Out-File "$(env temp)\elements\TrackBar.url"
                    $treeviewout        | Out-File "$(env temp)\elements\TreeView.url"
                    $vscrollbarout      | Out-File "$(env temp)\elements\VScrollBar.url"
                    $webbrowserout      | Out-File "$(env temp)\elements\WebBrowser.url"				
				#--------------------
                $mWebBrowser1.Navigate("$(env temp)\elements")
           
        $elements.add_Closed({
            if ($eleOK -eq "true")
            {elementswindow}})

            $elements.Show() 
                   [vds]::SetWindowPos($mForm.handle, -1, $(winpos $mForm.handle L), $(winpos $mForm.handle T), $(winpos $mForm.handle W), $(winpos $mForm.handle H),  0x0040)
               [vds]::SetWindowPos($elements.handle, -1, $(winpos $elements.handle L), $(winpos $elements.handle T), $(winpos $elements.handle W), $(winpos $elements.handle H), 0x0040)
[vds]::SetWindowPos($mFormGroupBox.handle, -1, $(winpos $mFormGroupBox.handle L), $(winpos $mFormGroupBox.handle T), $(winpos $mFormGroupBox.handle W), $(winpos $mFormGroupBox.handle H), 0x0040)
        }

$global:mfgby = 480
$global:mfgbx = 600

#DesignWindow



#elementswindow

#[System.Windows.Forms.Application]::Run($mForm)


switch(ext $args[0]) {
    dsproj {
            $scfile = (get-content $args[0] | Out-String).split((cr))[0]
            $content = (get-content $scfile | select-object -skip 1)
            $mAssignList.items.AddRange($content)
            $FastTab.TabPages.Add($scfile)
            $FastTab.SelectedIndex = ($FastTab.TabPages.Count - 1)
            $FastText = New-Object FastColoredTextBoxNS.FastColoredTextBox
            dialog property $FastText language $language
            dialog property $FastText dock "Fill"
            $FastTab.SelectedTab.Controls.Add($FastText)  
            if ($global:theme -eq "Dark")
            {$FastText.ForeColor = $light
            $FastText.BackColor = $dark
            $FastText.IndentBackColor = $dark}
            if ($global:theme -eq "Light"){
            $FastText.ForeColor = $dark
            $FastText.BackColor = $light
            $FastText.IndentBackColor = $light}         
            $FastText.OpenFile($scfile)
            $script:curdoc = (string $scfile)
            $FastTab.SelectedTab.Controls[0].IsChanged = $false
            $init.enabled = $true
    }
    dsform {
        $global:eleOK = "true"
        if ($global:dd -eq "false") {
            $global:dd = "true"
            DesignWindow | out-null
            elementswindow | out-null
            $mForm.Show()
            $a =[vds]::SetWindowPos($mForm.handle, -1, $(winpos $mForm.handle L), $(winpos $mForm.handle T), $(winpos $mForm.handle W), $(winpos $mForm.handle H), 0x0040)
            $a =[vds]::SetWindowPos($elements.handle, -1, $(winpos $elements.handle L), $(winpos $elements.handle T), $(winpos $elements.handle W), $(winpos $elements.handle H), 0x0040)
            $a = [vds]::SetWindowPos($mFormGroupBox.handle, -1, $(winpos $mFormGroupBox.handle L), $(winpos $mFormGroupBox.handle T), $(winpos $mFormGroupBox.handle W), $(winpos $mFormGroupBox.handle H), 0x0040)
            $mFormObj.Elements = Import-Clixml $args[0]
						inifile open $args[0]
            $mFormXTextBox2.Text = $(iniread Form Object)
            $mFormXTextBox.Text = $(iniread Form Text)
			$mFormGroupBox.Text = $(iniread Form Text)
			$mFormGroupBox.Top = $(iniread Form Top)
			$mFormGroupBox.Left = $(iniread Form Left)
            $mFormGroupBox.Height = $(iniread Form Height)
            $mFormGroupBox.Width = $(iniread Form Width)
            repaintForm | out-null
        }
    }

    default {
            $FastTab.TabPages.Add($args[0])
            $FastTab.SelectedIndex = ($FastTab.TabPages.Count - 1)
            $FastText = New-Object FastColoredTextBoxNS.FastColoredTextBox
            dialog property $FastText language $language
            dialog property $FastText dock "Fill"
            $FastTab.SelectedTab.Controls.Add($FastText) 
            if ($global:theme -eq "Dark")
            {$FastText.ForeColor = $light
            $FastText.BackColor = $dark
            $FastText.IndentBackColor = $dark}
            if ($global:theme -eq "Light"){
            $FastText.ForeColor = $dark
            $FastText.BackColor = $light
            $FastText.IndentBackColor = $light}         
            $FastText.OpenFile($args[0])
            $script:curdoc = (string $args[0])
            $FastTab.SelectedTab.Controls[0].IsChanged = $false
            $init.enabled = $true
    }
}

dialog show $FastTextForm


