#Adapted from Z.Alex https://gallery.technet.microsoft.com/scriptcenter/Powershell-Form-Builder-3bcaf2c7 MIT License

Add-Type -AssemblyName System.Windows.Forms                                                                                                                                                                                            
Add-Type -AssemblyName System.Drawing 
 
function mouseDown { 
 
    $Global:mCurFirstX = ([System.Windows.Forms.Cursor]::Position.X ) 
    $Global:mCurFirstY = ([System.Windows.Forms.Cursor]::Position.Y ) 
 
} 
 
function mouseMove ($mControlName) { 
 
    $mCurMoveX = ([System.Windows.Forms.Cursor]::Position.X ) 
    $mCurMoveY = ([System.Windows.Forms.Cursor]::Position.Y ) 
 
    if ($Global:mCurFirstX -ne 0 -and $Global:mCurFirstY -ne 0){ 
      
        $mDifX = $Global:mCurFirstX - $mCurMoveX  
        $mDifY = $Global:mCurFirstY - $mCurMoveY  
          
        $this.Left = $this.Left - $mDifX 
        $this.Top = $this.Top - $mDifY  
 
        $Global:mCurFirstX = $mCurMoveX  
        $Global:mCurFirstY = $mCurMoveY  
 
    } 
 
 
} 
 
function mouseUP ($mControlObj) { 
 
    $mCurUpX = ([System.Windows.Forms.Cursor]::Position.X ) 
    $mCurUpY = ([System.Windows.Forms.Cursor]::Position.Y ) 
 
    $Global:mCurFirstX = 0 
    $Global:mCurFirstY = 0 
 
 
    Foreach ($mElement In $Global:mFormObj.Elements){ 
 
        if ($mElement.Name -eq $this.name){ 

            foreach( $mProp in $mElement.Properties){ 
              
                Switch($mProp.Name){ 
 
                    'Top'{ $mProp.Value = $this.Top} 
                    'Left'{$mProp.Value = $this.Left} 
 
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
 
     $mList2 = New-Object System.Collections.ArrayList 
    [array]$mPropertyArr =  $mFormObj.Elements[$mElemetnsGrid.CurrentRow.Index].Properties  
    $mList2.AddRange($mPropertyArr) 
    $mPropertiesGrid.DataSource = $mList2 
    $mPropertiesGrid.Columns[0].ReadOnly=$true
    

         $mElemetnsGrid.CurrentCell = $null
$i = -1
    foreach( $row in $mElemetnsGrid.Rows)
{
    $i++
    if($row.Cells[0].Value.ToString() -eq $a)
    {

 $mElemetnsGrid.CurrentCell = $mElemetnsGrid[0,$i]
       $row.selected = $true
  }
 ElementsChanged
}


 
} 
 
Function DeleteElement { 
	$ev = $mFormObj.Elements[$mElemetnsGrid.CurrentRow.Index].Name
	if ($mFormObj.Elements.Count -gt 1){
		$Global:mFormObj.Elements = $mFormObj.Elements | ?{$_.Name -ne $ev}
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

 $mSameType = ($mFormObj.Elements | ?{$_.Type -like $mControlType.SelectedItem}) 

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
    
    $mSameType = ($mFormObj.Elements | ?{$_.Type -like $mControlType.SelectedItem}) 
 
    if($mSameType.count -ne $NUll -and $mSameType -ne $null) { 
 $tr = $true
        $mControlName=''+$mControlType.SelectedItem+($mSameType.count+1) 
 
     }elseif($mSameType.Count -eq $null -and $mSameType -ne $null){ 
 $tr = $true
        $mControlName=''+$mControlType.SelectedItem+'2' 
 
     }else{ 
      $tr = $true
        $mControlName=''+$mControlType.SelectedItem+'1' 
      
     } 

     $d1 = $mControlType.SelectedItem | Out-String

     $dummy = New-Object System.Windows.Forms.$d1
     $mForm.controls.Add($dummy)

    $mPropertiesArr+= AddProperty 'Text' $mControlName 
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

Function AddElement2 ($a) { 
    $mPropertiesArr =@() 
 
    $mSameType = ($mFormObj.Elements | ?{$_.Type -like $a}) 
 
    if($mSameType.count -ne $NUll -and $mSameType -ne $null) { 
 $tr = $true
        $mControlName=''+$a+($mSameType.count+1) 
 
     }elseif($mSameType.Count -eq $null -and $mSameType -ne $null){ 
 $tr = $true
        $mControlName=''+$a+'2' 
 
     }else{ 
      $tr = $true
        $mControlName=''+$a+'1' 
      
     } 

     $d1 = $a | Out-String

     $dummy = New-Object System.Windows.Forms.$d1
     $mForm.controls.Add($dummy)

 
    $mPropertiesArr+= AddProperty 'Text' $mControlName 
    $mPropertiesArr+= AddProperty 'Width' $dummy.width 
    $mPropertiesArr+= AddProperty 'Height' $dummy.height 
    $x = [System.Windows.Forms.Cursor]::Position.X - $mFormGroupBox.Left
    $y = [System.Windows.Forms.Cursor]::Position.Y - $mFormGroupBox.Top
    $mPropertiesArr+= AddProperty 'Top' ($y - ($dummy.height/2))
    $mPropertiesArr+= AddProperty 'Left' ($x - ($dummy.width/2) )
    $mForm.controls.remove($dummy)
 
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

    $mReturnControl = New-Object System.Windows.Forms.$ctrol

 
    $mReturnControl.Name = $mControl.Name 
 
    $mSizeX=$null 
    $mSizeY=$null 
 
    foreach ($mProperty in $mControl.Properties){ 
 
        switch ($mProperty.Name){ 
            'Top'   {$mReturnControl.Top=$mProperty.Value} 
            'Left'  {$mReturnControl.Left=$mProperty.Value}  
            'Width' {$mSizeX=$mProperty.Value} 
            'Height' {$mSizeY=$mProperty.Value} 
             'Text'  {$mReturnControl.Text=$mProperty.Value}
        } 
 
 
    } 
 
    $mReturnControl.Size = New-Object System.Drawing.Size($mSizeX,$mSizeY) 
    $mReturnControl.Add_MouseDown({MouseDown}) 
    $mReturnControl.Add_MouseMove({MouseMove ($mControl.Name)}) 
    $mReturnControl.Add_MouseUP({MouseUP}) 
 
    Return $mReturnControl 
 
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
 
    $mFormGroupBox.controls.clear() 
 
    Foreach ($mElement in $mFormObj.Elements){ 
 
        $mFormGroupBox.controls.add((AddControl $mElement)) 
 
    } 
 
} 
 
Function EditFormSize ($x,$y){ 
 
    $Global:mFormObj.SizeX = $X 
    $Global:mFormObj.SizeY = $Y 
 
    repaintForm 
 
} 
 
 
function ExportForm { 
 
    $mFormObj  
    $mExportString = 'import-module $PSScriptRoot\vds.psm1 -force 
    '
    $mExportString+= $mFormXTextBox2.Text+' = dialog create "'+$mFormGroupBox.Text+'" 0 0 '+$mFormGroupBox.Height+' '+$mFormGroupBox.Width+'
    ' 
    foreach ($mElement in $mFormObj.Elements){ 
 
        $mExportString+='$'+$mElement.Name+' = dialog add '+$mFormXTextBox2.Text+' '+$mElement.Type
        
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
 
    switch ($mProperty.Name)
    {
           Top {}
            Left {}
            Width {}
            Height {}
            Text {}

            default { 
 
                $mExportString+=' 
                $'+$mElement.Name+'.'+$mProperty.Name +'="'+$mProperty.Value+'"' 
 
            }
           } 
 
        } 
 
        $mExportString+='  
        ' 
 
    } 
 
    $mExportString+= 'dialog show '+$mFormXTextBox2.Text 
   
    $mFileName='' 
    $mFileName = get-filename '' 
    if ($mFileName -notlike ''){ 
            
        $mExportString > $mFileName 
 
    } 
} 
 
Function Get-FileName($initialDirectory)  {        
 
    $SaveFileDialog = New-Object System.Windows.Forms.SaveFileDialog 
    $SaveFileDialog.initialDirectory = $initialDirectory 
    $SaveFileDialog.filter = “Powershell Script (*.ps1)|*.ps1|All files (*.*)|*.*” 
    $SaveFileDialog.ShowDialog() | Out-Null 
    $SaveFileDialog.filename 
          
} 
 
 
$mForm = New-Object System.Windows.Forms.Form 
$mForm.AutoSize = $true 
$mForm.Text='DialogShell Designer' 
 
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
$mAddButton.Anchor = 'Left,Top' 
$mAddButton.Text = 'Add' 
$mAddButton.Left = 110 
$mAddButton.Top = 5 
$mAddButton.Size = New-Object System.Drawing.Size(50,23) 
$mAddButton.Add_Click({AddElement}) 

#$mForm.Controls.Add($mAddButton) 
 
$mFormLabel = New-Object System.Windows.Forms.Label 
$mFormLabel.Text = 'Title:' 
$mFormLabel.Top = 5
$mFormLabel.Left = 5
$mFormLabel.Width = 40
$mFormLabel.Anchor = 'Top,Left' 
$mFormLabel.TextAlign='MiddleRight' 
$mForm.Controls.Add($mFormLabel) 
 
$mFormXTextBox = New-Object System.Windows.Forms.TextBox 
$mFormXTextBox.left = 50
$mFormXTextBox.top = 5 
$mFormXTextBox.Width = 90
$mFormXTextBox.Anchor = 'Left,Top' 
$mFormXTextBox.Text="My Form"
$mFormXTextBox.add_KeyUp({$mFormGroupBox.Text = $mFormXTextBox.text})
$mForm.Controls.Add($mFormXTextBox) 

$mFormLabel2 = New-Object System.Windows.Forms.Label 
$mFormLabel2.Text = 'Name:' 
$mFormLabel2.Top = 5 
$mFormLabel2.Left = 100 
$mFormLabel2.Anchor = 'Left,Top' 
$mFormLabel2.Size = New-Object System.Drawing.Size(80,23) 
$mFormLabel2.TextAlign='MiddleRight' 
$mForm.Controls.Add($mFormLabel2) 
 
$mFormXTextBox2 = New-Object System.Windows.Forms.TextBox 
$mFormXTextBox2.left = 190
$mFormXTextBox2.top = 5 
$mFormXTextBox2.Width = 90
$mFormXTextBox2.Anchor = 'Left,Top' 
$mFormXTextBox2.Text='$MyForm'
$mFormXTextBox2.add_KeyUp({$mFormGroupBox.Text = $mFormXTextBox.text})
$mForm.Controls.Add($mFormXTextBox2) 
 
$mElemetnsGrid = New-Object System.Windows.Forms.DataGridView 
$mElemetnsGrid.size = New-Object System.Drawing.Size(205,300) 
$mElemetnsGrid.left=5 
$mElemetnsGrid.top=33 
$mElemetnsGrid.Anchor='Top,Left' 
$mElemetnsGrid.RowHeadersVisible =$false 
$mElemetnsGrid.Add_CellContentClick({ElementsChanged}) 
$mElemetnsGrid.Add_CellEndEdit({ElementsEndEdit}) 
$mForm.Controls.Add($mElemetnsGrid) 
 
$mPropertiesGrid = New-Object System.Windows.Forms.DataGridView 
$mPropertiesGrid.size = New-Object System.Drawing.Size(205,300) 
$mPropertiesGrid.left=235
$mPropertiesGrid.top=33 
$mPropertiesGrid.Anchor='Top,Left' 
$mPropertiesGrid.ColumnHeadersVisible=$true 
$mPropertiesGrid.RowHeadersVisible =$false 
$mPropertiesGrid.Add_CellEndEdit({PropertiesEndEdit}) 
$mForm.Controls.Add($mPropertiesGrid) 
 
$mDeleteButton = New-Object System.Windows.Forms.Button 
$mDeleteButton.size = New-Object System.Drawing.Size(205,23) 
$mDeleteButton.Text = 'Delete' 
$mDeleteButton.Left = 5 
$mDeleteButton.Top = 338 
$mDeleteButton.Anchor = 'Top,Left' 
$mDeleteButton.Add_Click({DeleteElement}) 
$mForm.Controls.Add($mDeleteButton) 
 
$mExportButton = New-Object System.Windows.Forms.Button 
$mExportButton.size = New-Object System.Drawing.Size(205,23) 
$mExportButton.text = 'Export' 
$mExportButton.Left = 235
$mExportButton.top = 338 
$mExportButton.Anchor='Top,Left' 
$mExportButton.Add_Click({ExportForm}) 
$mForm.Controls.Add($mExportButton) 
 
$Global:mFormObj = new-object PSCustomObject 

$Global:mFormObj | Add-Member -Name 'Elements' -MemberType NoteProperty -Value @() 

$Global:mCurFirstX =0  
$Global:mCurFirstY =0 


$mForm.add_Closed{$mFormGroupBox.Dispose()
#$elements.Dispose()
}

 function DesignWindow{
$Global:mFormGroupBox = New-Object System.Windows.Forms.Form
$Global:mFormGroupBox.Text = $mFormXTextBox.text 
$mFormGroupBox.height = $global:mfgby
$mFormGroupBox.width = $global:mfgbx
$mFormGroupBox.AllowDrop = $true
$mFormGroupBox.add_DragEnter{
if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
            foreach ($filename in $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop))  {
                AddElement2 ([io.path]::GetFileNameWithoutExtension($filename))
            }
            }
}

$mFormGroupBox.add_Resize{
$global:mfgby = $mFormGroupBox.height
$global:mfgbx = $mFormGroupBox.width
}

$mFormGroupBox.add_Closed{DesignWindow
repaintForm}

$mFormGroupBox.Show()
$mFormGroupBox.left = 500
}

function elementswindow{
    Add-Type -AssemblyName System.Windows.Forms 
    Add-Type -AssemblyName System.Drawing 
    $elements = New-Object System.Windows.Forms.Form 
    $elements.Text="Dialog Elements" 
    $elements.Size = New-Object System.Drawing.Size(300,500) 
     
 
        $mWebBrowser1 = New-Object System.Windows.Forms.WebBrowser 
                $mWebBrowser1.Top="0" 
                $mWebBrowser1.Left="0" 
                $mWebBrowser1.Anchor="Left,Top" 
                $mWebBrowser1.Dock = "Fill"
				$mWebBrowser1.Navigate($PSScriptRoot+"\Elements")
        $mWebBrowser1.Size = New-Object System.Drawing.Size(300,500) 
        $elements.Controls.Add($mWebBrowser1)
        $elements.add_Closed{elementswindow}
        $elements.Show() 
        }

$global:mfgby = 480
$global:mfgbx = 600

DesignWindow
elementswindow

[System.Windows.Forms.Application]::Run($mForm)
