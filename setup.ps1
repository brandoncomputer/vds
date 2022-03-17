$path = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $path
[Environment]::CurrentDirectory = $path
import-module .\vds.psm1
#$ErrorActionPreference = "SilentlyContinue"
$MyForm = dialog create "Setup Visual DialogShell" 0 0 676 366
  if ($(string $(curdir)) -ne 'c:\windows\system32'){
$MyForm.icon = "$(curdir)\setup\res\cog_go.ico"}
    $Label1 = dialog add $MyForm Label 5 217 1000 100 "Visual DialogShell"  
    
        $PictureBox1 = dialog add $MyForm PictureBox 38 95 100 50 
                dialog property $PictureBox1 BorderStyle "Fixed3D"  
        $PictureBox2 = dialog add $MyForm PictureBox 67 55 100 50 
                dialog property $PictureBox2 BorderStyle "Fixed3D"  
        $PictureBox3 = dialog add $MyForm PictureBox 40 16 100 50 
                dialog property $PictureBox3 BorderStyle "Fixed3D"  
        $PictureBox4 = dialog add $MyForm PictureBox 16 8 200 120 
                dialog property $PictureBox4 BorderStyle "Fixed3D" 
               dialog property $PictureBox1 backcolor "lightblue" 
               dialog property $PictureBox2 backcolor "lightblue" 
               dialog property $PictureBox3 backcolor "lightblue" 
               $Button1 = dialog add $MyForm Button 280 565 75 23 "Finish"  
               $Button2 = dialog add $MyForm Button 280 13 75 23 "Change"  
               $Label2 = dialog add $MyForm Label 285 103 500 23 "C:\Visual DialogShell"
        $Label3 = dialog add $MyForm Label 70 235 500 50 "Where DialogScript meets PowerShell"
        $Label4 = dialog add $MyForm Label 5 217 (676-227) 200 "Ipsum lorum"
        if ($(string $(curdir)) -ne 'c:\windows\system32'){
    dialog set $Label4 (get-content setup\license.md)}
        $agree = dialog add $MyForm CheckBox 225 585 200 20 Agree
        $agree.BringToFront()
        $Label3.BringToFront()
        $Label4.BringToFront()
        $PictureBox5 = dialog add $MyForm PictureBox 264 6 640 50 
        dialog property $PictureBox5 BorderStyle "Fixed3D"  
        dialog property $Label1 font "Segoe UI Black, 36"
        dialog property $Label3 font "Segoe UI Black, 16"
        dialog disable $Button1
        
        if ($args[0] -ne 'install')
        {
            $Label3.text = "Uninstall Visual DialogShell"
        dialog enable $Button1
         dialog hide $Label4
         dialog hide $agree
         
        }
        
        $agree.add_Click({
            if (equal $agree.Checked $true){
            dialog hide $Label4
        dialog enable $Button1}
        else
        {dialog disable $Button1
        dialog show $Label4}
        
        })
              $Button2.add_Click({$dirdlg = (dirdlg)
                    if ($dirdlg)
                        {dialog property $Label2 text $dirdlg}
                    })
                $Button1.add_Click({
                    
                    if ($Label3.text -eq "Uninstall Visual DialogShell")
           
                    {
                         directory delete $(regread "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell\" "InstallLocation")
                         directory delete "c:\programdata\microsoft\windows\start menu\programs\Visual DialogShell"
						 directory delete ([Environment]::GetFolderPath("System")+"\WindowsPowerShell\v1.0\Modules\vds")
                      #  New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR
                    #   See comments on these entries in the install section.
                    #   registry deleteitem "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$(regread HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell\ InstallLocation)\examples\vds-ide.exe"
                    #   registry deleteitem "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$(regread HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell\ InstallLocation)\compile-gue.exe"                       
                        registry deletekey "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell\"
                        registry deletekey "HKLM:\Software\Classes\.ds1"
                        registry deletekey "HKLM:\Software\Classes\DialogShell.Script"
                        registry deletekey "HKLM:\Software\Classes\.dsproj"
                        registry deletekey "HKLM:\Software\Classes\DialogShell.Project"
                        registry deletekey "HKLM:\Software\Classes\.dsform"
                        registry deletekey "HKLM:\Software\Classes\DialogShell.Form"
                        registry deletekey "HKLM:\Software\Classes\.pil"
                        registry deletekey "HKLM:\Software\Classes\DialogShell.Compile" 
                        info "Uninstall Complete"
                    dialog close $MyForm
                    }
                   else
                   { 
                    
                    directory create $Label2.Text
                    directory create "c:\windows\installer\dialogshell"
                    Get-ChildItem -Path .\setup\* -Recurse | Unblock-File
                    file copy .\setup\* $Label2.Text
                    # file copy .\setup\* $Label2.Text
                    file copy setup.ps1 "c:\windows\installer\dialogshell"
					file copy vds.psm1 "c:\windows\installer\dialogshell"
               		directory create ([Environment]::GetFolderPath("System")+"\WindowsPowerShell\v1.0\Modules\vds")
					file copy vds.psm1 ([Environment]::GetFolderPath("System")+"\WindowsPowerShell\v1.0\Modules\vds")
                    directory create ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell")
                    directory create ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell\examples")
                    directory create ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell\examples\en-US")
                    directory create ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell\res")
                    directory create ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell\elements")
                    file copy ("$(string $Label2.Text)\res\*") ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell\res")
                    file copy ("$(string $Label2.Text)\elements\*") ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell\elements")
                    file copy ("$(string $Label2.Text)\examples\*.ds1") ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell\examples")
                    file copy ("$(string $Label2.Text)\examples\*.mdb") ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell\examples")
                    file copy ("$(string $Label2.Text)\examples\en-us\*") ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell\examples\en-us")
                    file copy .\vds.psm1 \windows\system32\
                    $items = Get-ChildItem -Path ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell\examples")
                    foreach ($item in $items) {
                        if ($(trim $(ext $(string $item))) -eq 'ds1') {
                           $item.FullName | Out-File [Environment]::GetFolderPath("MyDocuments")+"\DialogShell\$(name $item.FullName).dsproj" 
                        }
                    }
                    
                 #   New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR
					
                    registry newkey "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\" "DialogShell"
                    registry newitem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell\" "DisplayName" String "Visual DialogShell"
                    registry newitem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell\" "InstallLocation" String "$(string $Label2.Text)"
                    registry newitem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell\" "UninstallString" String "cmd /c start /min $(chr 34)$(chr 34) C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -ep bypass -sta -file c:\windows\installer\dialogshell\setup.ps1"
                    registry newitem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell\" "Publisher" String "vds/pwsh community"
                if ($(regexists "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell\"))
                   {registry modifyitem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell\" "DisplayVersion" $(sysinfo dsver)
                   registry modifyitem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell\" "InstallDate" $(datetime).ToString('yyyyMMdd')
                   }
                   
                   else{
                   registry newitem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell\" "InstallDate" String $(datetime).ToString('yyyyMMdd')
                   registry newitem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell\" "DisplayVersion" String "0.2.7.8"}
                    registry newitem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell\" "DisplayIcon" String "$(string $Label2.Text)\res\icon.ico"
                  #  Uncomment these lines if unhappy with scaling blur. I'm leaving these commented at release, because devs need to be aware of the scaling issues.
                  #  There is a future task scheduled to fix this in the .manifest within the compiler, but it's at least 90 days out unless not-me works on it. 
                  #  See future.txt for a 'fun' project ~ which may or may not work. ~make sure to use it as a switch, and to update compile-gui accordingly.
                  #  registry newitem "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$(string $Label2.Text)\examples\vds-ide.exe" String "~ HIGHDPIAWARE"
                  #  registry newitem "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$(string $Label2.Text)\compile-gue.exe" String "~ HIGHDPIAWARE"
                    registry newkey  "HKLM:\Software\Classes\" .ds1
                    registry newitem "HKLM:\Software\Classes\.ds1\" "(Default)" String "DialogShell.Script"
                    registry newkey "HKLM:\Software\Classes\" "DialogShell.Script"
					registry newkey "HKLM:\Software\Classes\DialogShell.Script\" "DefaultIcon"
                    registry newitem "HKLM:\Software\Classes\DialogShell.Script\DefaultIcon" "(Default)" String "$(chr 34)$(string $Label2.Text)\res\terminal.ico$(chr 34)"
                    registry newkey "HKLM:\Software\Classes\DialogShell.Script\" "Shell"
                    registry newkey "HKLM:\Software\Classes\DialogShell.Script\Shell\" "Open"
                    registry newkey "HKLM:\Software\Classes\DialogShell.Script\Shell\Open\" "Command"
                    registry newitem "HKLM:\Software\Classes\DialogShell.Script\Shell\Open\Command" "(Default)" String "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -ep bypass -sta iex(get-content $(chr 39)%1$(chr 39) | out-string)"
					registry newkey "HKLM:\Software\Classes\DialogShell.Script\Shell\" "Edit"
                    registry newkey "HKLM:\Software\Classes\DialogShell.Script\Shell\Edit\" "Command"
                    registry newitem "HKLM:\Software\Classes\DialogShell.Script\Shell\Edit\Command" "(Default)" String "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -ep bypass -sta -file $(chr 34)$(string $Label2.Text)\examples\vds-ide.ps1$(chr 34) $(chr 34)%1$(chr 34)"
					registry newkey "HKLM:\Software\Classes\DialogShell.Script\Shell\" "Debug"
                    registry newkey "HKLM:\Software\Classes\DialogShell.Script\Shell\Debug\" "Command"
                   registry newitem "HKLM:\Software\Classes\DialogShell.Script\Shell\Debug\Command" "(Default)" String "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ep bypass -sta -file $(chr 34)$(string $Label2.Text)\compile\dialogshell.ps1$(chr 34) $(chr 34)%1$(chr 34) -cpath"
					#																					
					registry newkey "HKLM:\Software\Classes\" .dsproj
                    registry newitem "HKLM:\Software\Classes\.dsproj\" "(Default)" String "DialogShell.Project"
                    registry newkey "HKLM:\Software\Classes\" "DialogShell.Project"
					registry newkey "HKLM:\Software\Classes\DialogShell.Project\" "DefaultIcon"
                    registry newitem "HKLM:\Software\Classes\DialogShell.Project\DefaultIcon" "(Default)" String "$(string $Label2.Text)\res\icon.ico"
                    registry newkey "HKLM:\Software\Classes\DialogShell.Project\" "Shell"
                    registry newkey "HKLM:\Software\Classes\DialogShell.Project\Shell\" "Open"
                    registry newkey "HKLM:\Software\Classes\DialogShell.Project\Shell\Open\" "Command"
                    registry newitem "HKLM:\Software\Classes\DialogShell.Project\Shell\Open\Command" "(Default)" String "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -ep bypass -sta -file $(chr 34)$(string $Label2.Text)\examples\vds-ide.ps1$(chr 34) $(chr 34)%1$(chr 34)"
                    registry newkey "HKLM:\Software\Classes\" .dsform
                    registry newitem "HKLM:\Software\Classes\.dsform\" "(Default)" String "DialogShell.Form"
                    registry newkey "HKLM:\Software\Classes\" "DialogShell.Form"
                    registry newkey "HKLM:\Software\Classes\DialogShell.Form\" "Shell"
                    registry newkey "HKLM:\Software\Classes\DialogShell.Form\" "DefaultIcon"
                    registry newitem "HKLM:\Software\Classes\DialogShell.Form\DefaultIcon" "(Default)" String "$(string $Label2.Text)\res\application.ico"
                    registry newkey "HKLM:\Software\Classes\DialogShell.Form\Shell\" "Open"
                    registry newkey "HKLM:\Software\Classes\DialogShell.Form\Shell\Open\" "Command"
                    registry newitem "HKLM:\Software\Classes\DialogShell.Form\Shell\Open\Command" "(Default)" String "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -ep bypass -sta -file $(chr 34)$(string $Label2.Text)\examples\vds-ide.ps1$(chr 34) $(chr 34)%1$(chr 34)"
                   # registry newkey "HKLM:\Software\Classes\" .pil
                   # registry newitem "HKLM:\Software\Classes\.pil\" "(Default)" String "DialogShell.Compile"
                   # registry newkey "HKLM:\Software\Classes\" "DialogShell.Compile"
                   # registry newkey "HKLM:\Software\Classes\DialogShell.Compile\" "Shell"
                   # registry newkey "HKLM:\Software\Classes\DialogShell.Compile\Shell\" "Open"
                   # registry newkey "HKLM:\Software\Classes\DialogShell.Compile\Shell\Open\" "Command"
                   # registry newitem "HKLM:\Software\Classes\DialogShell.Compile\Shell\Open\Command" "(Default)" String "$(string $Label2.Text)\compile\compile-gui.exe $(chr 34)%1$(chr 34)"
                    
                    $buttonout          = "Text=Button$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.button?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\Button.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $checkboxout        = "Text=$(cr)Appearance=Normal$(cr)Threestate=$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.checkbox?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\CheckBox.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $checkedlistboxout  = "CheckOnClick=$(cr)UseTabStops=True$(cr)Multicolumn=$(cr)Selectionmode=One$(cr)Sorted=False$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.checkedlistbox?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\CheckedListBox.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $comboboxout        = "DropDownStyle=DropDown$(cr)Text=$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.combobox?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\ComboBox.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $datagridout        = "[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.datagrid?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\DataGrid.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $datagridviewout    = "[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.datagridview?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\DataGridView.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $datetimepickerout  = "Mindate=$(cr)Maxdate=$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.DateTimePicker?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\DateTimePicker.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $groupboxout        = "Text=$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.groupbox?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\GroupBox.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $hscrollbarout      = "Value=50$(cr)LargeChange=10$(cr)SmallChange=1$(cr)Minimum=0$(cr)Maximum=100$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.hscrollbar?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\HScrollBar.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $labelout           = "Text=$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.label?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\Label.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $linklabelout       = "Text=$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.linklabel?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\LinkLabel.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $listboxout         = "Sorted=$(cr)Selectionmode=One$(cr)Multicolumn=$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.listbox?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\ListBox.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $maskedtextboxout   = "Mask=00/00/0000$(cr)Text=00/00/0000$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.maskedtextbox?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\MaskedTextBox.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $menustripout       = "[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.menustrip?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\MenuStrip.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $monthcalendarout   = "Mindate=$(cr)Maxdate=$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.monthcalendar?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\MonthCalendar.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $numericupdownout   = "DecimalPlaces=0$(cr)Increment=1$(cr)Maximum=100$(cr)Minimum=0$(cr)Value=0$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.numericupdown?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\NumericUpDown.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $panel              = "BorderStyle=Fixed3D$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.panel?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\Panel.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $pictureboxout      = "BorderStyle=Fixed3D$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.picturebox?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\PictureBox.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $progressbarout     = "Minimum=0$(cr)Maximum=100$(cr)Value=0$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.progressbar?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\ProgressBar.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $radiobuttonout     = "Text=RadioButton$(cr)Checked=$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.radiobutton?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\RadioButton.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $richtextboxout     = "Text=RichTextBox$(cr)Dock=None$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.richtextbox?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\RichTextBox.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $statusstripout     = "Text=statusstrip$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.statusstrip?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\StatusStrip.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $textboxout         = "Text=Textbox$(cr)Multiline=$(cr)Maxlength=0$(cr)Wordwrap=true$(cr)Scrollbars=none$(cr)acceptstab=$(cr)acceptsreturn=$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.textbox?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\TextBox.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $toolstripout       = "Text=toolstrip$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.toolstrip?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\ToolStrip.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $trackbarout        = "Value=5$(cr)Minimum=0$(cr)Maximum=10$(cr)LargeChange=5$(cr)SmallChange=1$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.trackbar?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\TrackBar.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $treeviewout        = "[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.treeview?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\TreeView.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $vscrollbarout      = "Value=50$(cr)LargeChange=10$(cr)SmallChange=1$(cr)Minimum=0$(cr)Maximum=100$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.vscrollbar?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\VScrollBar.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    $webbrowserout      = "Dock=None$(cr)Url=$(cr)[InternetShortcut]$(cr)IDList=$(cr)URL=https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.webbrowser?view=netframework-4.7.2$(cr)IconFile=$(string $Label2.Text)\res\WebBrowser.ico$(cr)IconIndex=0$(cr)HotKey=0"
                    
                    $buttonout          | Out-File "$(string $Label2.Text)\elements\Button.url"
                    $checkboxout        | Out-File "$(string $Label2.Text)\elements\CheckBox.url"    
                    $checkedlistboxout  | Out-File "$(string $Label2.Text)\elements\CheckedListBox.url"   
                    $comboboxout        | Out-File "$(string $Label2.Text)\elements\ComboBox.url"
                    $datagridout        | Out-File "$(string $Label2.Text)\elements\DataGrid.url"
                    $datagridviewout    | Out-File "$(string $Label2.Text)\elements\DataGridView.url"
                    $datetimepickerout  | Out-File "$(string $Label2.Text)\elements\DateTimePicker.url"
                    $groupboxout        | Out-File "$(string $Label2.Text)\elements\GroupBox.url"
                    $hscrollbarout      | Out-File "$(string $Label2.Text)\elements\HScrollBar.url"
                    $labelout           | Out-File "$(string $Label2.Text)\elements\Label.url"
                    $linklabelout       | Out-File "$(string $Label2.Text)\elements\LinkLabel.url"
                    $listboxout         | Out-File "$(string $Label2.Text)\elements\ListBox.url"
                    $maskedtextboxout   | Out-File "$(string $Label2.Text)\elements\MaskedTextBox.url"
                    $menustripout       | Out-File "$(string $Label2.Text)\elements\MenuStrip.url"
                    $monthcalendarout   | Out-File "$(string $Label2.Text)\elements\MonthCalendar.url"
                    $numericupdownout   | Out-File "$(string $Label2.Text)\elements\NumericUpDown.url"
                    $panel              | Out-File "$(string $Label2.Text)\elements\Panel.url"
                    $pictureboxout      | Out-File "$(string $Label2.Text)\elements\PictureBox.url"
                    $progressbarout     | Out-File "$(string $Label2.Text)\elements\ProgressBar.url"
                    $radiobuttonout     | Out-File "$(string $Label2.Text)\elements\RadioButton.url"
                    $richtextboxout     | Out-File "$(string $Label2.Text)\elements\RichTextBox.url"
                    $statusstripout     | Out-File "$(string $Label2.Text)\elements\StatusStrip.url"
                    $textboxout         | Out-File "$(string $Label2.Text)\elements\TextBox.url"
                    $toolstripout       | Out-File "$(string $Label2.Text)\elements\ToolStrip.url"
                    $trackbarout        | Out-File "$(string $Label2.Text)\elements\TrackBar.url"
                    $treeviewout        | Out-File "$(string $Label2.Text)\elements\TreeView.url"
                    $vscrollbarout      | Out-File "$(string $Label2.Text)\elements\VScrollBar.url"
                    $webbrowserout      | Out-File "$(string $Label2.Text)\elements\WebBrowser.url"
                    
                    directory create "c:\programdata\microsoft\windows\start menu\programs\Visual DialogShell"
					#cmd /c start /min "" C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -ep bypass -sta -file c:\vds\trunk\examples\vds-ide.ps1
                    link ("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Visual DialogShell\Visual DialogShell IDE.lnk") ("powershell") ("$(string $Label2.Text)\examples") ("$(string $Label2.Text)\res\icon.ico,0") ("-windowstyle hidden -ep bypass -sta -file $(chr 34)$(string $Label2.Text)\examples\vds-ide.ps1$(chr 34)")
                    link ("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Visual DialogShell\DialogShell Console.lnk") ("powershell") ("$(string $Label2.Text)\compile") ("$(string $Label2.Text)\res\terminal.ico,0") ("-ep bypass -sta -file $(chr 34)$(string $Label2.Text)\compile\dialogshell.ps1$(chr 34)")
					

                    info "Install Complete"
                    
                    dialog close $MyForm
                }
   

                })
                
                
                
        dialog show $MyForm