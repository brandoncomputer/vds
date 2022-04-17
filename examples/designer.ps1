if ((Get-Module -ListAvailable vds).count -gt 1){
	$global:module = $(path $(Get-Module -ListAvailable vds)[0].path)
}
else {
	$global:module = $(path $(Get-Module -ListAvailable vds).path)
}

directory change "$module\examples"

$ErrorActionPreference = "SilentlyContinue"

    
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
    clipboard set "$scaleString$formexport$mExportString"
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
 
$mExportButton = dialog add $mform button 638 335 150 33 'Copy to Clipboard'

$mNewButton = dialog add $mform button 638 485 150 33 'New Form'

$mCancelButton = dialog add $mform button (638+35) 5 300 33 'Close'

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
			$mFormGroupBox.Top = $(iniread Form Top)
			$mFormGroupBox.Left = $(iniread Form Left)
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
$mForm.close()
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
# [vds]::SetWindowPos($mForm.handle, -1, $(winpos $mForm.handle L), $(winpos $mForm.handle T), $(winpos $mForm.handle W), $(winpos $mForm.handle H),  0x0040)
      #           [vds]::SetWindowPos($elements.handle, -1, $(winpos $elements.handle L), $(winpos $elements.handle T), $(winpos $elements.handle W), $(winpos $elements.handle H), 0x0040)
#[vds]::SetWindowPos($mFormGroupBox.handle, -1, $(winpos $mFormGroupBox.handle L), $(winpos $mFormGroupBox.handle T), $(winpos $mFormGroupBox.handle W), $(winpos $mFormGroupBox.handle H), 0x0040)
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
     #              [vds]::SetWindowPos($mForm.handle, -1, $(winpos $mForm.handle L), $(winpos $mForm.handle T), $(winpos $mForm.handle W), $(winpos $mForm.handle H),  0x0040)
       #        [vds]::SetWindowPos($elements.handle, -1, $(winpos $elements.handle L), $(winpos $elements.handle T), $(winpos $elements.handle W), $(winpos $elements.handle H), 0x0040)
#     [vds]::SetWindowPos($mFormGroupBox.handle, -1, $(winpos $mFormGroupBox.handle L), $(winpos $mFormGroupBox.handle T), $(winpos $mFormGroupBox.handle W), $(winpos $mFormGroupBox.handle H), 0x0040)
        }

$global:mfgby = 480
$global:mfgbx = 600

        $global:eleOK = "true"
            $global:dd = "true"
            DesignWindow | out-null
            elementswindow | out-null
           # $mForm.Show()
         #   $a =[vds]::SetWindowPos($mForm.handle, -1, $(winpos $mForm.handle L), $(winpos $mForm.handle T), $(winpos $mForm.handle W), $(winpos $mForm.handle H), 0x0040)
         #   $a =[vds]::SetWindowPos($elements.handle, -1, $(winpos $elements.handle L), $(winpos $elements.handle T), $(winpos $elements.handle W), $(winpos $elements.handle H), 0x0040)
         #   $a = [vds]::SetWindowPos($mFormGroupBox.handle, -1, $(winpos $mFormGroupBox.handle L), $(winpos $mFormGroupBox.handle T), $(winpos $mFormGroupBox.handle W), $(winpos $mFormGroupBox.handle H), 0x0040)
            if ($args[0]) {
			$mFormObj.Elements = Import-Clixml $args[0]
			inifile open $args[0]
            $mFormXTextBox2.Text = $(iniread Form Object)
            $mFormXTextBox.Text = $(iniread Form Text)
			$mFormGroupBox.Text = $(iniread Form Text)
			$mFormGroupBox.Top = $(iniread Form Top)
			$mFormGroupBox.Left = $(iniread Form Left)
            $mFormGroupBox.Height = $(iniread Form Height)
            $mFormGroupBox.Width = $(iniread Form Width)
			}
            repaintForm | out-null
			
			dialog show $mForm
		


