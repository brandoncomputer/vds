$PSSCriptRoot = Split-Path -Path $MyInvocation.MyCommand.Path; set-location $PSSCriptRoot; import-module $PSScriptRoot\..\vds.psm1 -force; invoke-expression $(get-content ..\vds.psm1 | out-string)

 $MyForm = dialog create "" 0 0 480 600
    $TextBox1 = dialog add $MyForm TextBox 40 69 100 20 "TextBox1" 
				dialog property $TextBox1 Multiline "" 
				dialog property $TextBox1 Maxlength "0" 
				dialog property $TextBox1 Wordwrap "true" 
				dialog property $TextBox1 Scrollbars "none" 
				dialog property $TextBox1 acceptstab "" 
				dialog property $TextBox1 acceptsreturn ""  
        $CheckedListBox1 = dialog add $MyForm CheckedListBox 106 105 120 94 
				dialog property $CheckedListBox1 CheckOnClick "" 
				dialog property $CheckedListBox1 UseTabStops "True" 
				dialog property $CheckedListBox1 Multicolumn "" 
				dialog property $CheckedListBox1 Selectionmode "One" 
				dialog property $CheckedListBox1 Sorted $false
				dialog property 
dialog property $MyForm SizeGripStyle "Hide"
dialog property $MyForm ShowInTaskbar $false
dialog property $MyForm ShowIcon $false
dialog property $CheckedListBox1 "Dock" "Fill"
dialog property $TextBox1 "Visible" $false

dialog properties $CheckedListBox1

#window normal $args[0]

$formh = $MyForm.Handle | Out-String

$txt = $TextBox1.Handle | Out-String
$f = $(fdiv $args[0] 1)/1

# inifile open $PSScriptRoot\CheckedListBox.ini

registry modifyitem hkcu:\software\dialogshell window $formh

window position $formh 0 24 400 400

while (($(regread hkcu:\software\dialogshell window)) -ne "ready")
{
wait .1
write-host waiting
}

[vds]::SetWindowLong($MyForm.Handle, -20, 0x20000000) | Out-Null
[vds]::SetWindowLong($MyForm.Handle, -16, 0x40000000) | Out-Null

 window fuse $MyForm.Handle $args[0]
 
$win = $args[0]/1

#write-host $win

$timer2 = timer 100

$timer2.add_Tick({
$timer2.enabled = $false
if ($CheckedListBox1.CheckedItems.count -gt 0)
{
$CheckedListBox1.CheckedItems | Set-Content checked.txt -Encoding Ascii
}
else
{"" | Set-Content checked.txt -Encoding Ascii}
registry modifyitem hkcu:\software\dialogshell check "load"
})

$timer = timer 100

$timer.add_Tick({
    
	$ini = $(regread hkcu:\software\dialogshell message)
	if ($ini -ne ""){
        switch ($ini) {
            default {
	            list add $CheckedListBox1 $ini
            }
            "nativeload" {
                foreach ($n in 1..100)
                {
                    list add $CheckedListBox1 $n
                }
            }
            "clear" {
                list clear $CheckedListBox1
            }
    }
	registry modifyitem hkcu:\software\dialogshell message ""
}
}
)

$CheckedListBox1.add_ItemCheck({
write-host "Working"
$timer2.enabled = $true
})

	
				dialog show $MyForm
	
