Add-Type -AssemblyName System.Windows.Forms,Microsoft.VisualBasic,System.Drawing, presentationframework, presentationcore, WindowsBase, System.ComponentModel

Add-Type @"
using System;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.ComponentModel;

public class vds {
[DllImport("user32.dll")]
public static extern bool InvertRect(IntPtr hDC, [In] ref RECT lprc);

[DllImport("user32.dll")]
public static extern IntPtr GetDC(IntPtr hWnd);

[DllImport("user32.dll")]
public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);

[DllImport("user32.dll")]
public static extern IntPtr WindowFromPoint(System.Drawing.Point p);
// Now working in pwsh 7 thanks to advice from seeminglyscience#2404 on Discord
[DllImport("user32.dll")]
public static extern IntPtr GetParent(IntPtr hWnd);
[DllImport("user32.dll")]
public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);
[DllImport("user32.dll")]
public static extern bool ShowWindow(int hWnd, WindowState nCmdShow);
public enum WindowState
    {
        SW_HIDE               = 0,
        SW_SHOW_NORMAL        = 1,
        SW_SHOW_MINIMIZED     = 2,
        SW_MAXIMIZE           = 3,
        SW_SHOW_MAXIMIZED     = 3,
        SW_SHOW_NO_ACTIVE     = 4,
        SW_SHOW               = 5,
        SW_MINIMIZE           = 6,
        SW_SHOW_MIN_NO_ACTIVE = 7,
        SW_SHOW_NA            = 8,
        SW_RESTORE            = 9,
        SW_SHOW_DEFAULT       = 10,
        SW_FORCE_MINIMIZE     = 11
    }
    
[DllImport("User32.dll")]
public static extern bool MoveWindow(int hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
[DllImport("User32.dll")]
public static extern bool GetWindowRect(int hWnd, out RECT lpRect);

      
[DllImport("user32.dll", EntryPoint="FindWindow")]
internal static extern int FWBC(string lpClassName, int ZeroOnly);
public static int FindWindowByClass(string lpClassName) {
return FWBC(lpClassName, 0);}

[DllImport("user32.dll", EntryPoint="FindWindow")]
internal static extern int FWBT(int ZeroOnly, string lpTitle);
public static int FindWindowByTitle(string lpTitle) {
return FWBT(0, lpTitle);}

[DllImport("user32.dll")]
public static extern IntPtr GetForegroundWindow();

[DllImport("user32.dll")]
public static extern IntPtr GetWindow(int hWnd, uint uCmd);

[DllImport("user32.dll")]    
     public static extern int GetWindowTextLength(int hWnd);
     
[DllImport("user32.dll")]
public static extern IntPtr GetWindowText(IntPtr hWnd, System.Text.StringBuilder text, int count);

[DllImport("user32.dll")]
public static extern IntPtr GetClassName(IntPtr hWnd, System.Text.StringBuilder text, int count);
     
[DllImport("user32.dll")]
    public static extern bool SetWindowPos(int hWnd, int hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
    
[DllImport ("user32.dll")]
public static extern bool SetParent(int ChWnd, int hWnd);

[DllImport("user32.dll")]
public static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);
    
[DllImport("User32.dll")]
public static extern bool SetWindowText(IntPtr hWnd, string lpString);


//CC-BY-SA
//Adapted from script by StephenP
//https://stackoverflow.com/users/3594883/stephenp
[DllImport("User32.dll")]
extern static uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);

public struct INPUT
    { 
        public int        type; // 0 = INPUT_MOUSE,
                                // 1 = INPUT_KEYBOARD
                                // 2 = INPUT_HARDWARE
        public MOUSEINPUT mi;
    }

public struct MOUSEINPUT
    {
        public int    dx ;
        public int    dy ;
        public int    mouseData ;
        public int    dwFlags;
        public int    time;
        public IntPtr dwExtraInfo;
    }
    
const int MOUSEEVENTF_MOVED      = 0x0001 ;
const int MOUSEEVENTF_LEFTDOWN   = 0x0002 ;
const int MOUSEEVENTF_LEFTUP     = 0x0004 ;
const int MOUSEEVENTF_RIGHTDOWN  = 0x0008 ;
const int MOUSEEVENTF_RIGHTUP    = 0x0010 ;
const int MOUSEEVENTF_MIDDLEDOWN = 0x0020 ;
const int MOUSEEVENTF_MIDDLEUP   = 0x0040 ;
const int MOUSEEVENTF_WHEEL      = 0x0080 ;
const int MOUSEEVENTF_XDOWN      = 0x0100 ;
const int MOUSEEVENTF_XUP        = 0x0200 ;
const int MOUSEEVENTF_ABSOLUTE   = 0x8000 ;

const int screen_length = 0x10000 ;

public static void LeftClickAtPoint(int x, int y, int width, int height)
{
    //Move the mouse
    INPUT[] input = new INPUT[3];
    input[0].mi.dx = x*(65535/width);
    input[0].mi.dy = y*(65535/height);
    input[0].mi.dwFlags = MOUSEEVENTF_MOVED | MOUSEEVENTF_ABSOLUTE;
    //Left mouse button down
    input[1].mi.dwFlags = MOUSEEVENTF_LEFTDOWN;
    //Left mouse button up
    input[2].mi.dwFlags = MOUSEEVENTF_LEFTUP;
    SendInput(3, input, Marshal.SizeOf(input[0]));
}

public static void RightClickAtPoint(int x, int y, int width, int height)
{
    //Move the mouse
    INPUT[] input = new INPUT[3];
    input[0].mi.dx = x*(65535/width);
    input[0].mi.dy = y*(65535/height);
    input[0].mi.dwFlags = MOUSEEVENTF_MOVED | MOUSEEVENTF_ABSOLUTE;
    //Left mouse button down
    input[1].mi.dwFlags = MOUSEEVENTF_RIGHTDOWN;
    //Left mouse button up
    input[2].mi.dwFlags = MOUSEEVENTF_RIGHTUP;
    SendInput(3, input, Marshal.SizeOf(input[0]));
}
//End CC-SA
[DllImport("user32.dll")] public static extern int SetForegroundWindow(IntPtr hwnd);


}

 public struct RECT

    {
    public int Left;
    public int Top; 
    public int Right;
    public int Bottom;
    }
"@  -ReferencedAssemblies System.Windows.Forms,System.Drawing,System.Drawing.Primitives,System.Net.Primitives,System.ComponentModel.Primitives,Microsoft.Win32.Primitives



<#      
        Function: FlashWindow
        Author: Boe Prox
        https://social.technet.microsoft.com/profile/boe%20prox/
        Adapted to VDS: 20190212
        License: Microsoft Limited Public License
#>

Add-Type @"
using System;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.ComponentModel;
public class vdsForm:Form {
[DllImport("user32.dll")]
public static extern bool RegisterHotKey(IntPtr hWnd, int id, int fsModifiers, int vk);
[DllImport("user32.dll")]
public static extern bool UnregisterHotKey(IntPtr hWnd, int id);
    protected override void WndProc(ref Message m) {
        base.WndProc(ref m);
        if (m.Msg == 0x0312) {
            int id = m.WParam.ToInt32();    
            foreach (Control item in this.Controls) {
                if (item.Name == "hotkey") {
                    item.Text = id.ToString();
                }
            }
        }
    }   
}
"@ -ReferencedAssemblies System.Windows.Forms,System.Drawing,System.Drawing.Primitives,System.Net.Primitives,System.ComponentModel.Primitives,Microsoft.Win32.Primitives

Add-Type -TypeDefinition @"
//"
using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;

public class Window
{
    [StructLayout(LayoutKind.Sequential)]
    public struct FLASHWINFO
    {
        public UInt32 cbSize;
        public IntPtr hwnd;
        public UInt32 dwFlags;
        public UInt32 uCount;
        public UInt32 dwTimeout;
    }

    //Stop flashing. The system restores the window to its original state. 
    const UInt32 FLASHW_STOP = 0;
    //Flash the window caption. 
    const UInt32 FLASHW_CAPTION = 1;
    //Flash the taskbar button. 
    const UInt32 FLASHW_TRAY = 2;
    //Flash both the window caption and taskbar button.
    //This is equivalent to setting the FLASHW_CAPTION | FLASHW_TRAY flags. 
    const UInt32 FLASHW_ALL = 3;
    //Flash continuously, until the FLASHW_STOP flag is set. 
    const UInt32 FLASHW_TIMER = 4;
    //Flash continuously until the window comes to the foreground. 
    const UInt32 FLASHW_TIMERNOFG = 12; 


    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    static extern bool FlashWindowEx(ref FLASHWINFO pwfi);

    public static bool FlashWindow(IntPtr handle, UInt32 timeout, UInt32 count)
    {
        IntPtr hWnd = handle;
        FLASHWINFO fInfo = new FLASHWINFO();

        fInfo.cbSize = Convert.ToUInt32(Marshal.SizeOf(fInfo));
        fInfo.hwnd = hWnd;
        fInfo.dwFlags = FLASHW_ALL | FLASHW_TIMERNOFG;
        fInfo.uCount = count;
        fInfo.dwTimeout = timeout;

        return FlashWindowEx(ref fInfo);
    }
}
"@

$global:ctscale = 1

$global:xmen = $false
$global:excelinit = $false
$global:fieldsep = "|"
$global:database = new-object System.Data.Odbc.OdbcConnection
set-alias run invoke-expression

function abs($a) {
<#
    .SYNOPSIS
     Returns the abslute value of a number.
     
    .DESCRIPTION
     VDS
    $number = -5
    if ($(abs $number) -gt 4)
    {console "It's greater than 4"}

    .LINK
    https://dialogshell.com/vds/help/index.php/abs
#>
    return [math]::abs($a)
}

function alt($a) {
    return "%$a"
<#
    .SYNOPSIS
     Sends the ALT key plus string. Only useful with 'window send'.
     
    .DESCRIPTION
     VDS
    window send $(winexists notepad) $(alt "F")
    .LINK
    https://dialogshell.com/vds/help/index.php/alt
#>
}

function asc($a) {
<#
    .SYNOPSIS
     Returns the ascii code number related to character $a.

    .DESCRIPTION
     VDS
     $(asc 'm')

    .LINK
    https://dialogshell.com/vds/help/index.php/asc
#>
    return [byte][char]$a
}

function ask($a,$b) {
    $ask = [System.Windows.Forms.MessageBox]::Show($a,$b,'YesNo','Info')
    return $ask
<#
    .SYNOPSIS
     Opens a dialog window to ask the user a question.
     
    .DESCRIPTION
     VDS
    if ($(ask "Is this the question?" "This is the title") -eq "Yes")
    {info "This is the question"}
    else
    {info "This is not the question"}
    .LINK
    https://dialogshell.com/vds/help/index.php/ask
#>
}

function beep {
    [console]::beep(500,300)
<#
    .SYNOPSIS
    Beeps
     
    .DESCRIPTION
     VDS
    beep
    
    .LINK
    https://dialogshell.com/vds/help/index.php?title=Beep
#>
}
function both($a, $b) {
    if (($a) -and ($b)) {
        return $true 
    } 
    else {
        return $false
    }
<#
    .SYNOPSIS
     Checks if both values are $true
     
    .DESCRIPTION
     VDS
    if ($(both 1 2)){console "Both 1 and 2 exists"}
    .LINK
    https://dialogshell.com/vds/help/index.php/both
#>
}
function chr ($a) {
    $a = $a | Out-String
    return [char][byte]$a
<#
    .SYNOPSIS
     Returns the ascii code to character
     
    .DESCRIPTION
     VDS
    $(chr 34)
    .LINK
    https://dialogshell.com/vds/help/index.php/chr
#>
}

function clipboard ($a,$b) {
    switch ($a) {
        append {
            Set-Clipboard -Append $b
        }
        clear {
            echo $null | clip
        }
        set {
            Set-Clipboard -Value $b
        }
    }
 <#
    .SYNOPSIS
    Performs clipboard operations
    Paramters: append, clear or set
     
    .DESCRIPTION
     VDS
    clipboard set $clip
    
    .LINK
    https://dialogshell.com/vds/help/index.php?title=Clipboard
 #>
 }
 
function clipbrd {
    return Get-Clipboard -Format Text
<#
    .SYNOPSIS
     Returns the text in the clipboard
     
    .DESCRIPTION
     VDS
    window send $(winexists notepad) $(clipbrd)
    .LINK
    https://dialogshell.com/vds/help/index.php/clipbrd
#>
}

function color ($a,$b,$c,$d) {
    switch ($a.toLower()) {
        name {return [System.Drawing.Color]::FromName($b)}
        rgb {return  [System.Drawing.Color]::FromArgb($b,$c,$d)}
        }
<#
    .SYNOPSIS
     Returns color by name or rgb
     
    .DESCRIPTION
     VDS
    Color
    .LINK
    https://dialogshell.com/vds/help/index.php/color
#>
}

function colordlg {
    $colorDialog = new-object System.Windows.Forms.ColorDialog
    $colorDialog.ShowDialog() | Out-Null
    if (($global:colordlg -eq $null) -or ($global:colordlg -eq "object")) {
        return $colorDialog
    }
    else {
            return $colorDialog.color.name
    }
<#
    .SYNOPSIS
     Produces a color selection dialog. 
     If 'option colordlg normal' has been set, this will return the friendly color name, otherwise it returns the entire colorDialog object.
     If 'option colordlg normal' is set, it may be unset using 'option colordlg object'.
         
    .DESCRIPTION
     VDS
     $color = $(colordlg); console $color.color.R; console $color.color.G; console $color.color.B

    .LINK
    https://dialogshell.com/vds/help/index.php/colordlg
#>
}
 
function console ($a,$b){
     switch ($a) {
         read {
             return read-host -prompt $b
         }
         write {
             write-host $b
         }
         default {
             write-host $a
         }
     }
 <#
     .SYNOPSIS
     Performs console write or read operations
      
     .DESCRIPTION
      VDS
     $read = $(console read)
    
     .LINK
     https://dialogshell.com/vds/help/index.php?title=Console
 #>
}

 function count ($a) {
    return $a.items.count
<#
    .SYNOPSIS
     Returns the count of items in an object, usually a listbox. 

    .DESCRIPTION
     VDS
     $c = $(count $listbox1)

    .LINK
    https://dialogshell.com/vds/help/index.php/count
#>
}
function cr {
    return chr(13)
<#
    .SYNOPSIS
     A carriage return, this is usually followed by a line feed. 

    .DESCRIPTION
     VDS
     info "Return a new line $(cr) here."

    .LINK
    https://dialogshell.com/vds/help/index.php/cr
#>
}

function csv ($a,$b,$c,$d,$e,$f)
{
    switch ($a)
    {
        read{
            if ($e){
                while ($i -lt $e) {
                $build += ($i+1),($i+2)
                $i = $i+2
                }
            }
            else {
                while ($i -lt 256) {
                $build += ($i+1),($i+2)
                $i = $i+2
                }
            }

            $csv = Import-Csv $b -header $build.ForEach({ $_ })
            $i = 0
            $csv | %{
            $i = $i+1
                if ($i -eq $d){
                return $_.$c
                }
            }
        }
        write {
            if ($f){
                while ($i -lt $f) {
                $build += ($i+1),($i+2)
                $i = $i+2
                }
            }
            else {
                while ($i -lt 256) {
                $build += ($i+1),($i+2)
                $i = $i+2
                }
            }

            $csv = Import-Csv $b -header $build.ForEach({ $_ })
            $i = 0
            $csv | %{
            $i = $i+1
                if ($i -eq $d){
                $_.$c = $e
                return $csv
                }
            }
        }
        count {
            if ($c){
                while ($i -lt $c) {
                $build += ($i+1),($i+2)
                $i = $i+2
                }
            }
            else {
                while ($i -lt 256) {
                $build += ($i+1),($i+2)
                $i = $i+2
                }
            }

            $csv = Import-Csv $b -header $build.ForEach({ $_ })
            return $csv.count       
        }
        save {
        $b | export-csv $c -NoTypeInformation
        $Content = Get-content $c | select-object -skip 1
        $Content | out-file $c -Encoding utf8       
        }
    }
     <#
     .SYNOPSIS
     Manipulate CSV files 
      
     .DESCRIPTION
      VDS
      #There are 300 columns. Read cell A1
      $csv = $(csv read c:\temp\temp.csv 1 1 300)
      
      #There are less than 255 columns. Read cell B2
      $csv = $(csv read c:\temp\temp.csv 2 2)
      
      #There are 300 columns. Write to cell A1, return the whole CSV back.
      $csv = $(csv write c:\temp\temp.csv 1 1 NotMyCow 300)
      
      #There are less than 255 columns. Write cell B2, return the whole CSV back.
      $csv = $(csv write c:\temp\temp.csv 2 2 Beans)
      
      #Get the row count of a CSV
      $csv = $(csv count c:\temp\temp.csv)
      
      #Save CSV file
      csv save $csv c:\temp\temp.csv
     
     .LINK
     https://dialogshell.com/vds/help/index.php?title=csv
 #>
} 

function ctrl($a) {
    return "^$a"
<#
    .SYNOPSIS
     Sends the CTRL key plus string. Only useful with 'window send'.
     
    .DESCRIPTION
     VDS
    window send $(winexists notepad) $(ctrl "s")
    
    .LINK
    https://dialogshell.com/vds/help/index.php/ctrl
#>
}

 function curdir {
    return $(trim (Get-Location | Select-Object -expandproperty Path | Out-String))
<#
    .SYNOPSIS
     Returns the current directory as string
     
    .DESCRIPTION
     VDS
    $c = $(curdir)
    directory change c:\windows
    rem do some stuff
    directory change $c
    
    .LINK
    https://dialogshell.com/vds/help/index.php/curdir
#>
}

 function database($a,$b) {
     switch ($a) {
         Open {
             $database.connectionstring = "DSN="+$b
             $database.Open()
         }
         Close {
             $database.Close()
         }
         Execute {
             $command = New-object System.Data.Odbc.OdbcCommand($b,$database)
             $getdata = new-object System.Data.Dataset
             (new-object System.Data.odbc.Odbcdataadapter($command)).Fill($getdata)
             return $getdata.tables
         }
     }
 <#
     .SYNOPSIS
     Performs ODBC database operations, open requires the connection name, close closes the connection, execute is a sql command that returns data tables.
      
     .DESCRIPTION
      VDS
     $q = $(database execute 'select * from table where name like $string')
     
     .LINK
     https://dialogshell.com/vds/help/index.php?title=Database
 #>  
 }
 
 function date($a)
 {
 return [System.Convert]::ToDateTime($a)
  <#
     .SYNOPSIS
     Converts string to date (for math operations)
      
     .DESCRIPTION
      VDS
    write-host $(date '7/17/2020 8:52:33 pm').AddDays(-1)
     
     .LINK
     https://dialogshell.com/vds/help/index.php?title=date
 #>  
 }
 
 function datetime {
    return Get-Date
<#
    .SYNOPSIS
     Returns the current date and time.
     
    .DESCRIPTION
     VDS
     $(datetime)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/datetime
#>
} 

function decrypt ($a, $b){
	if ($b){
		[byte[]]$b = $b.split(" ")
		$secure = $a | ConvertTo-SecureString -Key $b
		$user = "inconsequential"
		$credObject = New-Object System.Management.Automation.PSCredential -ArgumentList $user, $secure
		return ($credObject.GetNetworkCredential().Password)
	}
	else{
		$secure = $a | ConvertTo-SecureString 
		$user = "inconsequential"
		$credObject = New-Object System.Management.Automation.PSCredential -ArgumentList $user, $secure
		return ($credObject.GetNetworkCredential().Password)
	}
<#
    .SYNOPSIS
    Decrypt an encrypted secret.
     
    .DESCRIPTION
     VDS
    $encrypt = 'Hello'
	$b = $(encrypt $encrypt 'Aes')
	$vals = $b.Split($(fieldsep))
	info $(decrypt $vals[0] $vals[1])
    
    .LINK
    https://dialogshell.com/vds/help/index.php/decrypt
#>
}

 function dialog($a,$b,$c,$d,$e,$f,$g,$h) {
     switch ($a) {
         add {
             switch ($c) {
                 default {
                     if ($c -eq $null) {
                         $Control = New-Object System.Windows.Forms.$b
                     }
                     else {
                         $Control = New-Object System.Windows.Forms.$c
                     }
                     if ($d -is [int]) {
                         $Control.Top = $d * $ctscale
                         $Control.Left = $e * $ctscale
                         $Control.Width = $f * $ctscale
                         $Control.Height = $g * $ctscale
                         $Control.Text = $h
                     }
                     if ($c -ne $null) {
                         $b.Controls.Add($Control)
                     }
                     return $Control
                 }
                 items {
                     $c.items.add($d)
                 }
                 statusstrip {
                     $statusstrip = new-object System.Windows.Forms.StatusStrip
                     $b.controls.add($statusstrip)
                     $ToolStripStatusLabel = New-Object System.Windows.Forms.ToolStripStatusLabel
                     $statusstrip.Items.AddRange($ToolStripStatusLabel)
                     return $statusstrip
                 }
                 menustrip { 
                     if ($global:xmen -ne $true) {
                         $global:menuribbon = new-object System.Windows.Forms.MenuStrip
                         $b.Controls.Add($global:menuribbon)
                         $global:xmen = $true
                     }
                                 
                     $xmenutitle = new-object System.Windows.Forms.ToolStripMenuItem
                     $xmenutitle.Name = $d
                     $xmenutitle.Text = $d
                     $global:menuribbon.Items.add($xmenutitle) | Out-Null
                     
                     foreach ($split in $e.split(",")) {
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
                             $item.Add_Click({
                                     &menuitemclick $this
                             })
                             $item.Add_MouseUp({
                                     &menuitemmouseup $this
                             })                              
                         } 
                         else {
                             $item = new-object System.Windows.Forms.ToolStripSeparator
                             $item.name = $split
                             $item.text = $split                 
                         }                       
                         $xmenutitle.DropDownItems.Add($item) | Out-Null     
                     }   
                     return $xmenutitle                  
                 }
                 toolstrip {
                     $toolbuttons = New-Object System.Windows.Forms.ToolStrip
					 $toolbuttons.imagescalingsize = new-object System.Drawing.Size([int]($ctscale * 16),[int]($ctscale * 16))
					 $toolbuttons.Height = $toolbuttons.Height * $ctscale
                     foreach ($split in $d.split(",")) {
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
                             $item.Add_Click({&toolstripitemclick $this})
                         }
                         else {
                             $item = new-object System.Windows.Forms.ToolStripSeparator
                             $item.name = $split
                             $item.text = $split                 
                         }                       
                         $toolbuttons.Items.Add($item) | Out-Null                    
                     }
                         $b.Controls.Add($toolbuttons)
                          return $toolbuttons
                 }
             }
         }
         image {
                if ($(substr $c 0 2) -eq 'ht') {
                    $b.image = $(streamimage $c)
                }
                else {
                    $b.image = $(fileimage $c)
                }
         } 
        backgroundimage { 
                if ($(substr $c 0 2) -eq 'ht') {
                    $b.backgroundimage = $(streamimage $c)
                }
                else {
                    $b.backgroundimage = $(fileimage $c)
                }
         }
         clear {
             $b.Text = ""
         }
         clearsel {
             $b.Items.RemoveAt($b.SelectedIndex)
         }
         close {
             $b.Close()
         }
         create {
             $Form = [vdsForm] @{
             ClientSize = New-Object System.Drawing.Point 0,0}
             $Form.Text = $b
             $Form.Top = $c * $ctscale
              $Form.Left = $d * $ctscale
             $Form.Width = $e * $ctscale
             $Form.Height = $f * $ctscale
             return $Form
         }
         cursor {
             $b.Cursor = $c
         } #https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.cursors.appstarting?view=netframework-4.7.2
         enable {
             $b.enabled = $true
         }
         disable {
             $b.enabled = $false
         }
         focus {
             $b.focus()
         }
         hide {
             $b.visible = $false
         }
         name {
             $b.Name = $c
         }
         popup { 
                     $xpopup = New-Object System.Windows.Forms.ContextMenuStrip
                     
                     foreach ($split in $c.split(",")) {
                         if ($split -ne "-")
                         {   $item = new-object System.Windows.Forms.ToolStripMenuItem
                             $isplit = $split.split("|")
                             $item.name = $isplit[0] 
                            if ($isplit[1])
                            {
                                if ($(substr $isplit[1] 0 2) -eq 'ht') {
                                    $item.image = $(streamimage $isplit[1])
                                }
                                else {
                                    $item.image = $(fileimage $isplit[1])
                                }
                            }
                             $item.text = $isplit[0]
                             $item.Add_Click({&menuitemclick $this})
                             $item.Add_MouseUp({
                                     &menuitemmouseup $this
                             }) 
                         }
                         else {
                             $item = new-object System.Windows.Forms.ToolStripSeparator
                             $item.name = $split
                             $item.text = $split                 
                         }                       
                         $xpopup.Items.Add($item) | Out-Null                 
                     }
                         $b.ContextMenuStrip = $xpopup
                         return $xpopup
                 }
         properties {
             return $b | Get-Member
         } #Remains for backwards compatibility. Please use dlgprops
         property {
                
                if ($d -notmatch "color"){
                    if ($($c -match "color")) {
                        $s = $d.split(",")
                        if ($s[1]){
                            $d = $(color rgb $s[0] $s[1] $s[2])
                        }
                        else {
                        $d = $(color name $d)
                        }
                    }
                }
                
                if ($d -notmatch "font"){
                    if ($c.toLower() -eq 'font') {
                            $s = $d.split(",")
                            $d = $(font $s[0] ($s[1]/1))
                    }
                }
                
             $b.$c = $d
            # write-host $d.GetType();
         }
         remove {    
             $b.dispose()
         } 
         run {
              $global:apprunning = $true
              [System.Windows.Forms.Application]::Run($b) | Out-Null
              #Only useful when using vds.psm1 as a module to PowerShell in scenarios where the same form in a ps1 file must be called multiple times.
          }
          set {
              $b.Text = $c
          }
          setpos {
              $b.Top = $c * $ctscale
              $b.Left = $d * $ctscale
              $b.Width = $e * $ctscale
              $b.Height = $f * $ctscale
          }
          settip {
              $t = New-Object System.Windows.Forms.Tooltip
              $t.SetToolTip($b, $c)
          }
          show {
              if ($global:apprunning -eq $true) {
                  $b.Show() | Out-Null
              }
              else {
                  $global:apprunning = $true
                  [System.Windows.Forms.Application]::Run($b) | Out-Null
              }
          }
          showmodal {
              $b.ShowDialog() | Out-Null
          }
          snap {
              switch ($c)
              {
                  on {$b.MaximizeBox = $tue}
                  off {$b.MaximizeBox = $false}
              } # not working during runtime for switching back.
          }
          title {
              $b.Text = $c
          }  #partial implementation - requires form as $b param          
      }
      <#
      .SYNOPSIS
      Controls creation and manipulation of forms
      add (control) int:top int:left int:width int:height string:text
      statusstrip
      menustrip
      toolstrip
      image
      clear
      clearsel
      close
      create string:caption int:top int:left int:width int:height
      cursor (Arrow, Cross, Default, Hand, Help, HSplit, IBeam, No, NoMove2D, NoMoveHoriz, NoMoveVert, PanEast, PanNE, PanNorth, PanNW, PanSE, PanSouth, PanSW, PanWest, SizeAll, SizeNESW, SizeNS, SizeNWSE, SizeWE, UpArrow, VSplit, WaitCursor)
      enable
      disable
      focus
      hide
      name
      popup
      property
      remove
      set
      setpos
      settip
      show
      showmodal
      snap
      title
      
      
      .DESCRIPTION
      VDS
      $MyForm = dialog create MyForm 0 0 800 600
      $textbox1 = dialog add $MyForm $textbox 10 10 100 20
      $menu = dialog add $MyForm menustrip "&File" ('&New|Ctrl+N|'+$(curdir)+'\..\res\application.ico,&Open|Ctrl+O,&Save|Ctrl+S,Save &As,-,Page Set&up...,&Print|Ctrl+P,-,E&xit')
      $toolstrip1 = dialog add $form1 toolstrip "Buttonx1|c:\temp\verisign.bmp|Test,-,Buttonx2|c:\temp\verisign.bmps|Test"
      $statustrip = dialog add $MyForm statusstrip
      $button1 = dialog add $MyForm button 40 10 100 20 "Button1"
      dialog set $statusstrip "Status"
      dialog image button1 ($(curdir)+'\my.png')
      dialog clear $textbox1
      dialog clearsel $list1
      dialog close $MyForm
      dialog cursor $MyForm Arrow
      dialog enable $textbox1
      dialog disable $textbox1
      dialog focus $textbox1
      dialog hide $textbox1
      dialog name $textbox1 textbox1
      $popup = dialog popup $MyForm1 "Beans,Rice"
      dialog property $textbox1 text Text
      dialog remove $textbox1
      dialog setpos $textbox1 10 10 20 100
      dialog settip $textbox1 'Do not wait'
      dialog show $MyForm
      dialog showmodal $MyForm
      dialog snap $MyFrom
      dialog title $MyForm "New Caption"  
      
      .LINK
  https://dialogshell.com/vds/help/index.php/Dialog
      #>  
}

function differ ($a,$b) {
    return $a - $b
<#
    .SYNOPSIS
    Returns the subtractrion result.
     
    .DESCRIPTION
     VDS
     $(differ 4 2)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/differ
#>
}

function dirdlg($a,$b) {
$dirdlg = New-Object System.Windows.Forms.FolderBrowserDialog
$dirdlg.description = $a
$dirdlg.rootfolder = $b
    if($dirdlg.ShowDialog() -eq "OK")   {
        $folder += $dirdlg.SelectedPath
    }
        return $folder
<#
    .SYNOPSIS
    Allows use of dialog to browse for folder and returns the result as string. 
    The first paramater is the text to display "Select main folder", the second paramater is the start folder.
    Permitted start folder locations are as follows: Desktop, Programs, MyDocuments, Personal, Favorites, Startup, Recent, SendTo, StartMenu, MyMusic, MyVideos, DesktopDirectory, MyComputer, NetworkShortcuts, Fonts, Templates, CommonStartMenu, 
    CommonPrograms, CommonStartup, CommonDesktopDirectory, ApplicationData, PrinterShortcuts, LocalApplicationData, InternetCache, Cookies, History, CommonApplicationData, Windows, System, ProgramFiles, MyPictures, UserProfile, SystemX86, 
    ProgramFilesX86, CommonProgramFiles, CommonProgramFilesX86, CommonTemplates, CommonDocuments, CommonAdminTools, AdminTools, CommonMusic, CommonPictures, CommonVideos, Resources, LocalizedResources, CommonOemLinks, CDBurning
    
    .DESCRIPTION
     VDS
     $mainfolder = $(dirdlg "Select Main Folder" "CDBurning")
     
    .LINK
    https://dialogshell.com/vds/help/index.php/dirdlg
#>
} #partial implementation - root folder constrained to certain values by powershell. 

function directory($a,$b,$c) {
    switch ($a) {
        change 
        {
            Set-Location $b
            [Environment]::CurrentDirectory = $b
        }
        create 
        {
            New-Item -ItemType directory -Path $b
        }
        delete 
        {
            Remove-Item -path $b -recurse -force
        }
        rename 
        {
            Rename-Item -Path $b -NewName $c
        }
    }
<#
    .SYNOPSIS
    Performs directory operations: change, create, delete, rename
     
    .DESCRIPTION
     VDS
    directory change c:\
    
    .LINK
    https://dialogshell.com/vds/help/index.php/Directory
#>  
}

function div ($a,$b) {
    return $a / $b
    <#
    .SYNOPSIS
    Returns the quotient of a dividend and a divisor.
     
    .DESCRIPTION
     VDS
     $(div 4 2)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/div
#>
}

function dlgname($a) {
    return $a.name
<#
    .SYNOPSIS
    Returns the name property of a dialog element
     
    .DESCRIPTION
     VDS
     $(name $textbox1)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/dlgname
#>
}

function dlgpos ($a,$b) {
    switch ($b) {
        T {
            return $a.Top / $ctscale
        }
        L {
            return $a.Left / $ctscale
        }
        W {
            return $a.Width / $ctscale
        }
        'H' {
            return $a.Height / $ctscale
        }
    }
<#
    .SYNOPSIS
    Returns the an element of a dialog position, T for top, L for left, W for width or H for height.
     
    .DESCRIPTION
     VDS
     $(dlgpos $textbox1 T)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/dlgpos
#>  
} #partial implementation

function dlgprops ($a,$b,$c) {
    if ($b -eq $null) {
        return $a | Get-Member | Out-String
    }
    else {
        return ($a | select -ExpandProperty $b | Out-String).Trim()
    }
<#
    .SYNOPSIS
    Returns properties (1) or property (2 params) of a dialog element.
     
    .DESCRIPTION
     VDS
    console $(dlgprops $textbox1)
    $textbox1text = $(dlgprops $textbox1 text)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/dlgprops
#>
}

function dlgtext($a) {  
    return $a.Text
<#
    .SYNOPSIS
    Returns the text of a dialog element.
     
    .DESCRIPTION
     VDS
     $(dlgtext $textbox1)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/dlgtext
#>
}

function encrypt ($a,$b){
	$SecureString = $a | ConvertTo-SecureString -AsPlainText -Force
	if ($b){
			$AESKey = New-Object Byte[] 32
			[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($AESKey)
			$encrypt = $SecureString | ConvertFrom-SecureString -Key $AESKey
			return $encrypt+$fieldsep+$AESKey
	}
	else
	{
			return ($SecureString | ConvertFrom-SecureString)
	}
<#
    .SYNOPSIS
    Decrypt an encrypted secret.
     
    .DESCRIPTION
     VDS
    $encrypt = 'Hello'
	$b = $(encrypt $encrypt 'Aes')
	$vals = $b.Split($(fieldsep))
	info $(decrypt $vals[0] $vals[1])
    
    .LINK
    https://dialogshell.com/vds/help/index.php/encrypt
#>
}

function env($a) {
    $loc = Get-Location | select -ExpandProperty Path
    Set-Location Env:
    $return = Get-ChildItem Env:$a | select -ExpandProperty Value
    Set-Location $loc;return $return
<#
    .SYNOPSIS
    Returns an environmental variable.
     
    .DESCRIPTION
     VDS
     $windir = $(env windir)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/env
#>
}

function equal($a, $b) {
    if ($a -eq $b) {
        return $true 
    } 
    else {
        return $false
    }
<#
    .SYNOPSIS
    Returns if two values are equal.
     
    .DESCRIPTION
     VDS
     if ($(equal 4 2))
     {console "Hey, four and two really are equal!"}
     
    .LINK
    https://dialogshell.com/vds/help/index.php/equal
#>
}

function error {
    return $LASTEXITCODE
<#
    .SYNOPSIS
    Returns the last error exit code.
     
    .DESCRIPTION
     VDS
     console $(error)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/error
#>
}

function esc {
    return $(chr 27)
<#
    .SYNOPSIS
    Returns the escape key, useful with window send.
     
    .DESCRIPTION
     VDS
     window send $(winexists "Save as...") $(esc)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/esc
#>
} 

function eternium($a,$b,$c,$d,$e){ 
$global:errpref = $ErrorActionPreference
    switch($a){
        open {
            $global:ie = new-object -ComObject "InternetExplorer.Application"
            $global:ie.visible = $true
            $global:ie.navigate($b)
            eternium busy
        }
        hide {
        $global:ie.visible = $false
        }
        show {
        $global:ie.visible = $true
        }
        busy {while($global:ie.Busy) { Start-Sleep -s 1 }
        }
        navigate {
        if ($b){$global:ie.Navigate($b)
           eternium busy}           
           else{
           return $global:ie.LocationURL
           }
           }
        get {
                if ($b.toLower() -eq "innertext") {
                    $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.getElementsByTagName('*')[$i].innerText.toString())
                        if ($item -eq $c){
                            return $global:ie.document.getElementsByTagName('*')[$i]
                            
                        }
                        $i = $i+1
                    }
                    $ErrorActionPreference = $global:errpref
                }
                elseif($b.toLower() -eq "innerhtml") {
                    $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.getElementsByTagName('*')[$i].innerhtml.toString())
                        if ($item -eq $c){
                            return $global:ie.document.getElementsByTagName('*')[$i]
                            
                        }
                        $i = $i+1
                    }
                    $ErrorActionPreference = $global:errpref
                }
                elseif($b.toLower() -eq "outerhtml") {
                    $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.getElementsByTagName('*')[$i].outerhtml.toString())
                        if ($item -eq $c){
                            return $global:ie.document.getElementsByTagName('*')[$i]
                            
                        }
                        $i = $i+1
                    }
                    $ErrorActionPreference = $global:errpref
                }
                elseif($b.toLower() -eq "outertext") {
                    $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.getElementsByTagName('*')[$i].outertext.toString())
                        if ($item -eq $c){
                            return $global:ie.document.getElementsByTagName('*')[$i]
                            
                        }
                        $i = $i+1
                    }
                    $ErrorActionPreference = $global:errpref
                }
                else {
                        $global:ie.document.getElementsByTagName('*') | % {
                        if ($_.getAttributeNode($b).Value -eq $c) {
                             return $_ 
                        }
                    }
                }
            }
            compatget {
                    if ($b.toLower() -eq "innertext") {
                    $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.IHTMLDocument3_getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i].innerText.toString())
                        if ($item -eq $c){
                            return $global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i]
                            
                        }
                        $i = $i+1
                    }
                    $ErrorActionPreference = $global:errpref
                }
                elseif($b.toLower() -eq "innerhtml") {
                $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.IHTMLDocument3_getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i].innerhtml.toString())
                        if ($item -eq $c){
                            return $global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i]
                            
                        }
                        $i = $i+1
                    }
                    $ErrorActionPreference = $global:errpref
                }
                elseif($b.toLower() -eq "outerhtml") {
                $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.IHTMLDocument3_getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i].outerhtml.toString())
                        if ($item -eq $c){
                            return $global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i]
                           
                        }
                        $i = $i+1
                    }
                     $ErrorActionPreference = $global:errpref
                }
                elseif($b.toLower() -eq "outertext") {
                $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.IHTMLDocument3_getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i].outertext.toString())
                        if ($item -eq $c){
                            return $global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i]
                           
                        }
                        $i = $i+1
                    }
                     $ErrorActionPreference = $global:errpref
                }
                else {
                        $global:ie.document.IHTMLDocument3_getElementsByTagName('*') | % {
                        if ($_.getAttributeNode($b).Value -eq $c) {
                             return $_ 
                        }
                    }
                }
            }

            set {
                if ($b.toLower() -eq "innertext") {
                    $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.getElementsByTagName('*')[$i].innerText.toString())
                        if ($item -eq $c){
                            $global:ie.document.getElementsByTagName('*')[$i].$d = $e
                            
                        }
                        $i = $i+1
                    }
                    $ErrorActionPreference = $global:errpref
                }
                elseif($b.toLower() -eq "innerhtml") {
                    $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.getElementsByTagName('*')[$i].innerhtml.toString())
                        if ($item -eq $c){
                            $global:ie.document.getElementsByTagName('*')[$i].$d = $e
                            
                        }
                        $i = $i+1
                    }
                    $ErrorActionPreference = $global:errpref
                }
                elseif($b.toLower() -eq "outerhtml") {
                    $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.getElementsByTagName('*')[$i].outerhtml.toString())
                        if ($item -eq $c){
                            $global:ie.document.getElementsByTagName('*')[$i].$d = $e
                            
                        }
                        $i = $i+1
                    }
                    $ErrorActionPreference = $global:errpref
                }
                elseif($b.toLower() -eq "outertext") {
                    $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.getElementsByTagName('*')[$i].outertext.toString())
                        if ($item -eq $c){
                            $global:ie.document.getElementsByTagName('*')[$i].$d = $e
                            
                        }
                        $i = $i+1
                    }
                    $ErrorActionPreference = $global:errpref
                }
                else {
                        $global:ie.document.getElementsByTagName('*') | % {
                        if ($_.getAttributeNode($b).Value -eq $c) {
                             $_.$d = $e
                        }
                    }
                }
            }
            compatset {
                    if ($b.toLower() -eq "innertext") {
                    $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.IHTMLDocument3_getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i].innerText.toString())
                        if ($item -eq $c){
                            $global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i].$d = $e
                            
                        }
                        $i = $i+1
                    }
                    $ErrorActionPreference = $global:errpref
                }
                elseif($b.toLower() -eq "innerhtml") {
                $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.IHTMLDocument3_getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i].innerhtml.toString())
                        if ($item -eq $c){
                            $global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i].$d = $e
                            
                        }
                        $i = $i+1
                    }
                    $ErrorActionPreference = $global:errpref
                }
                elseif($b.toLower() -eq "outerhtml") {
                $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.IHTMLDocument3_getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i].outerhtml.toString())
                        if ($item -eq $c){
                            $global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i].$d = $e
                            
                        }
                        $i = $i+1
                    }
                    $ErrorActionPreference = $global:errpref
                }
                elseif($b.toLower() -eq "outertext") {
                $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.IHTMLDocument3_getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i].outertext.toString())
                        if ($item -eq $c){
                           $global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i].$d = $e
                            
                        }
                        $i = $i+1
                    }
                    $ErrorActionPreference = $global:errpref
                }
                else {
                        $global:ie.document.IHTMLDocument3_getElementsByTagName('*') | % {
                        if ($_.getAttributeNode($b).Value -eq $c) {
                             $_.$d = $e
                        }
                    }
                }
            }

        
        oldset {
            try{
                $global:ie.document.getElementsByTagName('*') | % {
                    if ($_.getAttributeNode($b).Value -eq $c) {
                        $_.$d = $e
                    }
                }
            }
            catch{
                $global:ie.document.IHTMLDocument3_getElementsByTagName('*') | % {
                    if ($_.getAttributeNode($b).Value -eq $c) {
                         $_.$d = $e
                    }
                } 
            }
        }

            click {
                if ($b.toLower() -eq "innertext") {
                    $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.getElementsByTagName('*')[$i].innerText.toString())
                        if ($item -eq $c){
                            $global:ie.document.getElementsByTagName('*')[$i].click()
                            eternium busy
                            
                        }
                        $i = $i+1
                    }
                    $ErrorActionPreference = $global:errpref
                }
                elseif($b.toLower() -eq "innerhtml") {
                    $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.getElementsByTagName('*')[$i].innerhtml.toString())
                        if ($item -eq $c){
                            $global:ie.document.getElementsByTagName('*')[$i].click()
                            eternium busy
                            
                        }
                        $i = $i+1
                    }
                    $ErrorActionPreference = $global:errpref
                }
                elseif($b.toLower() -eq "outerhtml") {
                    $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.getElementsByTagName('*')[$i].outerhtml.toString())
                        if ($item -eq $c){
                            $global:ie.document.getElementsByTagName('*')[$i].click()
                            eternium busy
                            
                        }
                        $i = $i+1
                    }
                    $ErrorActionPreference = $global:errpref
                }
                elseif($b.toLower() -eq "outertext") {
                    $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.getElementsByTagName('*')[$i].outertext.toString())
                        if ($item -eq $c){
                            $global:ie.document.getElementsByTagName('*')[$i].click()
                            eternium busy
                           
                        }
                        $i = $i+1
                    }
                     $ErrorActionPreference = $global:errpref
                }
                else {
                $ErrorActionPreference = 'SilentlyContinue'
                        $global:ie.document.getElementsByTagName('*') | % {
                        if ($_.getAttributeNode($b).Value -eq $c) {
                             $_.click()
                            eternium busy
                        }
                    }
                    $ErrorActionPreference = $global:errpref
                }
            }
            compatclick {
                    if ($b.toLower() -eq "innertext") {
                    $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.IHTMLDocument3_getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i].innerText.toString())
                        if ($item -eq $c){
                            $global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i].click()
                            eternium busy
                           
                        }
                        $i = $i+1
                    }
                     $ErrorActionPreference = $global:errpref
                }
                elseif($b.toLower() -eq "innerhtml") {
                $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.IHTMLDocument3_getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i].innerhtml.toString())
                        if ($item -eq $c){
                            $global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i].click()
                            eternium busy
                           
                        }
                        $i = $i+1
                    }
                     $ErrorActionPreference = $global:errpref
                }
                elseif($b.toLower() -eq "outerhtml") {
                $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.IHTMLDocument3_getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i].outerhtml.toString())
                        if ($item -eq $c){
                            $global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i].click()
                            eternium busy
                            
                        }
                        $i = $i+1
                    }
                    $ErrorActionPreference = $global:errpref
                }
                elseif($b.toLower() -eq "outertext") {
                $ErrorActionPreference = 'SilentlyContinue'
                    $i = 0
                    while ($i -le $global:ie.document.IHTMLDocument3_getElementsByTagName('*').length()) {
                        $item = ($global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i].outertext.toString())
                        if ($item -eq $c){
                           $global:ie.document.IHTMLDocument3_getElementsByTagName('*')[$i].click()
                            eternium busy
                        
                        }
                        $i = $i+1
                    }
                    $ErrorActionPreference = $global:errpref
                }
                else {
                        $global:ie.document.IHTMLDocument3_getElementsByTagName('*') | % {
                        if ($_.getAttributeNode($b).Value -eq $c) {
                            $_.click()
                            eternium busy
                        }
                    }
                }
            }

        oldclick {
            try{ 
                $global:ie.document.getElementsByTagName('*') | % {
                    if ($_.getAttributeNode($b).Value -eq $c) {
                        $_.click()
                        eternium busy
                    }
                }
            }
            catch{
                $global:ie.document.IHTMLDocument3_getElementsByTagName('*') | % {
                    if ($_.getAttributeNode($b).Value -eq $c) {
                         $_.click()
                         eternium busy
                    }
                }
            }
        }
    }
<#
    .SYNOPSIS
    Automates Internet Explorer.
     
    .DESCRIPTION
     VDS
    eternium open 'https://google.com'
    eternium navigate 'https://dialogshell.com'
    $currentpage = $(eternium navigate)
    $value = $(eternium get 'id' 'Text1').value
    $innertext = $(eternium get 'innerhtml' 'Hello<BR>There').innertext
    eternium set 'class' 'Text1' 'value' 'new value'
    eternium click 'name' 'button1'
        $value = $(eternium compatget 'id' 'Text1').value
        $innertext = $(eternium compatget 'innerhtml' 'Hello<BR>There').innertext
        eternium compatset 'class' 'Text1' 'value' 'new value'
        eternium compatclick 'name' 'button1'
    eternium hide
    eternium show
    
    .LINK
    https://dialogshell.com/vds/help/index.php/eternium
#>  
}

function event {
    return (Get-PSCallStack)[1].Command
<#
    .SYNOPSIS
    Returns the last command called. This probably needs reworked, use sparsly.
     
    .DESCRIPTION
     VDS
     $event = $(event)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/event
#>
}

function excel($a,$b,$c,$d)
{
    if ($global:excelinit -eq $false){
        $global:excelinit = $true
        $global:excelVDS = new-object -comobject excel.application
    }
    switch ($a,$b){
        connect {
            return $global:excelinit
        }
        new {
            return $global:excelVDS.Workbooks.add()
        }
        show {
            $global:excelVDS.visible = $true
        }
        hide {
            $global:excelVDS.visible = $false
        }
        AddWorksheet {
            $b.Worksheets.Add()
        }
        Open {
            $global:excelVDS.Workbooks.Open($b)
        }
        Save {
            $global:excelVDS.Workbooks.Save()
        }
        SaveAs {
            $global:excelVDS.ActiveWorkbook.SaveAs($b)
        }
        SelectSheet {
            $global:excelVDS.Worksheets.Item($b).Select()
        }
        SetCell {
            $global:excelVDS.ActiveSheet.Cells.Item($b,$c) = $d
        }
        GetCell {
                return $global:excelVDS.ActiveSheet.Cells.Item($b,$c).value
        }
        DeleteColumn {
                $global:excelVDS.ActiveSheet.Columns[$b].Delete()
        }
        DeleteRow {
                $global:excelVDS.ActiveSheet.Rows[$b].Delete()
        }
        InsertColumn {
                $global:excelVDS.ActiveSheet.Columns[$b].Insert()
        }
        InsertRow {
                $global:excelVDS.ActiveSheet.Rows[$b].Insert()
        }
        ColumnCount {
                return $global:excelVDS.ActiveSheet.UsedRange.Columns.Count
        }
        RowCount {
                return $global:excelVDS.ActiveSheet.UsedRange.Rows.Count
        }
    }
<#
    .SYNOPSIS
    Automates Microsoft Excel
     
    .DESCRIPTION
     VDS
     #begin automation
     $excel = excel connect
     
     #Create new workbook
     $workbook = excel new
     
     #Show Excel
     excel show 
     
     #Hide Excel
     excel hide
     
     #Add worksheet
     excel AddWorksheet
     
     #Open Workbooks
     excel open c:\temp\excel.xlsx
     
     #Save workbook
     excel save
     
     #Workbook Save As
     excel saveas c:\temp\save-excel.xlsx
     
     #Select sheet   
     excel SelectSheet Book2     
     
     #Set cell value 'B2' 'value'
     excel SetCell 2 1 value
     
     #Get cell 'B2' value
     $cell = excel GetCell 2 1
     
     #Delete column 'C'
     excel DeleteColumn 3
     
     #Delete row 3
     excel DeleteRow 3
     
     #Insert Column before 'A'
     excel InsertColumn 1
     
     #Insert row between 1 and 2
     excel InsertRow 2
     
     #Get the used column count
     $cc = excel ColumnCount
     
     #Get the row count
     $rc = excel RowCount    
     
    .LINK
    https://dialogshell.com/vds/help/index.php/excel
#>
}

function exit ($a) {
exit $a
<#
    .SYNOPSIS
    Exits with a specific code
     
    .DESCRIPTION
     VDS
    exit 21
    
    .LINK
    https://dialogshell.com/vds/help/index.php/Exit
#>
} #partial implementation - does not work with gosubs, this is technically now the same as error

function exitwin($a) {
    switch ($a) {
        logoff {
        Invoke-RDUserLogoff -HostServer "localhost" -UnifiedSessionID 1
        } #This is probably wrong.
        shutdown {
        Stop-Computer}
        restart {
        Restart-Computer
        }
    }
<#
    .SYNOPSIS
    Logoff, shutdown or restart
     
    .DESCRIPTION
     VDS
    exitwin restart
    
    .LINK
    https://dialogshell.com/vds/help/index.php/Exitwin
#>
}

function expandproperty($a,$b){
return $(select-object -inputobject $a -expandproperty $b)
<#
    .SYNOPSIS
    Expands the property [property] of inputobject [inputobject]
     
    .DESCRIPTION
     VDS
     $major = $(expandproperty [System.Environment]::OSVersion.Version major)
     #major being the property.
     
    .LINK
    https://dialogshell.com/vds/help/index.php/expandproperty
#>
}

function ext($a) {
    $split = $a.Split('.')
    return $split[$split.count -1]
<#
    .SYNOPSIS
    returns the three character extension of a file name.
     
    .DESCRIPTION
     VDS
    $file = $(filedlg "Files|*.*")
    $ext = $(ext $file)
    info $ext
     
    .LINK
    https://dialogshell.com/vds/help/index.php/ext
#>
}

function fabs($a) {
    return [math]::abs($a)
<#
    .SYNOPSIS
    Returns the absolute value of a number.
     
    .DESCRIPTION
     VDS
    info $(fabs -10)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/fabs
#>
}

function fadd($a,$b) {
    return $a + $b
<#
    .SYNOPSIS
    Returns the sum of two values.
     
    .DESCRIPTION
     VDS
    info $(fadd 2 2)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/fadd
#>
}

function fatn($a,$b) {
    return [math]::atn($a / $b)
<#
    .SYNOPSIS
    Returns the arctangent of y over x.
     
    .DESCRIPTION
     VDS
    info $(fatn $y $x)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/fatn
#>
}

function fcos {
    Param ($a);
    return [math]::cos($a)
<#
    .SYNOPSIS
    Returns cosine.
     
    .DESCRIPTION
     VDS
    info $(cos $a)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/fcos
#>
}
function fdiv ($a,$b) {
    return $a / $b
<#
    .SYNOPSIS
    Returns the quotient of a division problem.
     
    .DESCRIPTION
     VDS
    info $(fdiv $a $b)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/fdiv
#>
}

function fexp($a) {
    return [math]::exp($a)
<#
    .SYNOPSIS
    Returns exponent.
     
    .DESCRIPTION
     VDS
    info $(exp $a)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/fexp
#>
}

function fieldsep {
    return $fieldsep
<#
    .SYNOPSIS
    Returns the fieldsep specified by option fieldsep
     
    .DESCRIPTION
     VDS
    info $a.split($(fieldsep))[0]
     
    .LINK
    https://dialogshell.com/vds/help/index.php/fieldsep
#>
}



function file($a,$b,$c,$d) {
    switch ($a) {
        copy {
            if ((substr $b 0 4) -eq 'http'){
                $file = New-Object System.Net.WebClient
                $file.DownloadFile($b,$c)
            }
            else {
                copy-item -path $b -destination $c -recurse
            }
        }
        move {
            Move-Item -path $b -destination $c
        }
        delete {
            Remove-Item -path $b -force
        }
        rename {
            Rename-Item -Path $b -NewName $c
        }
        setdate {
            $b = Get-Item $b; $b.LastWriteTime = New-object DateTime $c
        }
        setattr {
            switch ($c) {
                set {
                    $b =(Get-ChildItem $b -force)
                    $b.Attributes = $b.Attributes -bor ([System.IO.FileAttributes]$d).value__
                }
                unset {
                    $b =(Get-ChildItem $b -force)
                    $b.Attributes = $b.Attributes -bxor ([System.IO.FileAttributes]$d).value__
                }
            }
        }
        default {
            if (Test-Path -path $a) {
                return $true
            }
            else {
                return $false
            }
        }
    }
<#
    .SYNOPSIS
    copy, delete, rename, setdate or setattr
     
    .DESCRIPTION
     VDS
    file copy $file1 file2
    file delete $file1
    file rename $file1 $rename
    file setdate $(datetime)
    file setattr $file set Hidden
    
    .LINK
    https://dialogshell.com/vds/help/index.php/File
#>
}

function filedlg($a,$b,$c) {
    if ($c -ne "save") {
        $filedlg = New-Object System.Windows.Forms.OpenFileDialog
        $filedlg.initialDirectory = $b
        $filedlg.filter = $a
        $filedlg.ShowDialog() | Out-Null
        return $filedlg.FileName
    }
    else {
        $filedlg = New-Object System.Windows.Forms.SaveFileDialog
        $filedlg.initialDirectory = $b
        $filedlg.filter = $a
        $filedlg.ShowDialog() | Out-Null
        return $filedlg.FileName
    }
<#
    .SYNOPSIS
    Returns the results of a file selection dialog. An optional 'save' parameter is available to generate a file save dialog.
     
    .DESCRIPTION
     VDS
    $file = $(filedlg 'Text Files|*.txt' $(windir)) 
     
    .LINK
    https://dialogshell.com/vds/help/index.php/filedlg
#>
}#partial implementation - excluded multi. Needs fixed.

function fileimage ($a){
return [System.Drawing.Image]::FromFile($a)
<#
    .SYNOPSIS
     Creates a image from a file.
     
    .DESCRIPTION
     VDS
    $PictureBox1.image = $(fileimage 'c:\temp\eternium.png')
    
    .LINK
    https://dialogshell.com/vds/help/index.php/streamimage
#>  
}

function fint ($a) {
    return [int]$a
<#
    .SYNOPSIS
    Returns the value as integer.
     
    .DESCRIPTION
     VDS
    $(fint 19)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/fint
#>
}

function fln ($a){
    return [math]::log($a)
<#
    .SYNOPSIS
    Returns logarithm
     
    .DESCRIPTION
     VDS
    $a = $(fln 64)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/fln
#>
}

function flog ($a) {
    return [math]::log($a)
<#
    .SYNOPSIS
    Returns log
     
    .DESCRIPTION
     VDS
    console $(log 15)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/flog
#>
}

function fmul($a,$b) {
    return $a * $b
    <#
    .SYNOPSIS
    Returns the product of a multiplication problem.
     
    .DESCRIPTION
     VDS
    $a = $(fmul 4 4)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/fmul
#>
}

function focus($a) {
    return $a.ActiveControl
<#
    .SYNOPSIS
    Returns the active control of the parameter
     
    .DESCRIPTION
     VDS
    $a = $(focus $MyForm)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/focus
#>
} #partial implementation - in this version, must specify the form as a parameter

function font($a,$b,$c,$d,$e,$f) {
$font = ([System.Drawing.Font]::new($a, $b/1))
if ($c){
$font.$c = $d}
if ($e){
$font.$e = $f}
return $font
<#
    .SYNOPSIS
    Returns a font object
     
    .DESCRIPTION
     VDS
    $font = (font "Segoe UI Black" "16")
    
    .LINK
    https://dialogshell.com/vds/help/index.php/font
#>
}

function fontdlg($a,$b) {
    $fontdlg = new-object windows.forms.fontdialog
    $fontdlg.showcolor = $true
    $fontdlg.ShowDialog()
    return $fontdlg
<#
    .SYNOPSIS
    Returns a font dialog, the properties of which must be parsed.
     
    .DESCRIPTION
     VDS
    $fontdlg = $(fontdlg)
    $RichEdit.SelectionFont = $fontdlg.font
    
    .LINK
    https://dialogshell.com/vds/help/index.php/fontdlg
#>
} #partial implementation - does not preset font upon displaying the dialog.

function format($a,$b) {
    return $a | % {
        $_.ToString($b)
    }
<#
    .SYNOPSIS
    Formats a string according to specified paramater
     
    .DESCRIPTION
     VDS
    console $(format 8888888888 '###-###-####')
    
    .LINK
    https://dialogshell.com/vds/help/index.php/format
#>
} 

function frac($a) {
    $a = $a | Out-String 
    return  $a.split(".")[1]/1
<#
    .SYNOPSIS
    Returns the fractional portion of a number as integer.
     
    .DESCRIPTION
     VDS
    info $(frac 3.14)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/frac
#>
} 

function fsep($a) {
    return $fieldsep
<#
    .SYNOPSIS
    Returns the fieldsep specified by option fieldsep
     
    .DESCRIPTION
     VDS
    info $a.split($(fsep))[0]
     
    .LINK
    https://dialogshell.com/vds/help/index.php/fsep
#>
} 

function fsin ($a){
    return [math]::sin($a)
<#
    .SYNOPSIS
    Returns the math sine of a number
     
    .DESCRIPTION
     VDS
    console $(fsin 1)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/fsin
#>
}

function fsqt ($a){
    return [math]::sqt($a)
<#
    .SYNOPSIS
    Returns the square root of a number
     
    .DESCRIPTION
     VDS
    console $(fsqt 4)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/fsqt
#>
}

function fsub ($a,$b) {
    return $a - $b
<#
    .SYNOPSIS
    Returns the difference of two numbers
     
    .DESCRIPTION
     VDS
    console $(fsub 2 2)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/fsub
#>
}

function greater($a, $b) {
    if (($a) -gt ($b)) 
    {
        return $true
    } 
    else {
        return $false
    }
<#
    .SYNOPSIS
    Returns true if one value is greater than another.
     
    .DESCRIPTION
     VDS
    console $(greater 4 2)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/greater
#>
}

function gridview($a) { 
return $a | Out-Gridview
<#
    .SYNOPSIS
    Outputs result to a gridview dialog. Only valid on systems with Powershell ISE installed.
     
    .DESCRIPTION
     VDS
    gridview $(ls)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/gridview
#>
}

function hex($a){
    return $a | format-hex
<#
    .SYNOPSIS
    Returns hex
     
    .DESCRIPTION
     VDS
    console $(hex 15)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/hex
#>
}

function hotkey($a,$b,$c,$d) {
[vdsForm]::RegisterHotKey($a.handle,$b,$c,$d) | out-null
    if ($global:hotkeyobject -ne $true) {
        $hotkey = dialog add $a label 0 0 0 0
        dialog name $hotkey hotkey
        $hotkey.add_TextChanged({
            if ($this.text -ne ""){
                hotkeyEvent $this.text
            }
            $this.text = ""
        })
    $global:hotkeyobject = $true
    }
<#
    .SYNOPSIS
    Adds a hotkey to the form
     
    .DESCRIPTION
     VDS
    Registers a hotkey by ID to fire function hotkeyEvent by vkey function.
    Example:
    hotkey $Form 1 $null (vkey home)
    hotkey $FastTextForm 1 ((vkey alt)+(vkey control)) (vkey v)
    function hotkeyEvent ($a) {
    switch ($a){
        1 {
        $FastTextForm.Text = "Visual DialogShell $(sysinfo dsver)"
        }
    }
}
    
    .LINK
    https://dialogshell.com/vds/help/index.php/hotkey
#>
}

 function htmlhelp ($a) {
    start-process -filepath hh.exe -argumentlist $a
 <#
    .SYNOPSIS
    Jumps to a specfied location in a compiled html file
     
    .DESCRIPTION
     VDS
    htmlhelp mk:@MSITStore:C:\Users\Brandon\Documents\textpad.chm::/Help/new.htm
    
    .LINK
    https://dialogshell.com/vds/help/index.php/htmlhelp
 #>
 }

function index($a) {
    return $a.SelectedIndex
<#
    .SYNOPSIS
    Returns the selected index of a control
     
    .DESCRIPTION
     VDS
    $index = $(index $listbox1)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/index
#>
}

function info($a,$b) {
    [System.Windows.Forms.MessageBox]::Show($a,$b,'OK',64) | Out-Null
 <#
    .SYNOPSIS
    Displays a message and a title
     
    .DESCRIPTION
     VDS
    info "Message" "Title"
    
    .LINK
    https://dialogshell.com/vds/help/index.php/info
 #>
}

 function inifile ($a,$b,$c,$d) {
    switch ($a) { 
        open {
            $global:inifile = $b
        } 
        write {
            $Items = New-Object System.Collections.Generic.List[System.Object]
            $content = get-content $global:inifile
            if ($content) {
                $Items.AddRange($content)
            }
            if ($Items.indexof("[$b]") -eq -1) {
                $Items.add("")
                $Items.add("[$b]")
                $Items.add("$c=$d")
                $Items | Out-File $global:inifile
                }
            else {
                For ($i=$Items.indexof("[$b]")+1; $i -lt $Items.count; $i++) {
                if ($Items[$i].length -gt $c.length) {
                    if ($Items[$i].substring(0,$c.length) -eq $c -and ($tgate -ne $true)) {
                            $Items[$i] = "$c=$d"
                            $tgate = $true
                        }
                    }
                    if ($Items[$i].length -gt 0) {
                        if (($Items[$i].substring(0,1) -eq "[") -and ($tgate -ne $true)) {
                            $i--
                            $Items.insert(($i),"$c=$d")
                            $tgate = $true
                            $i++
                        }
                    }               
                }
                if ($Items.indexof("$c=$d") -eq -1) {
                    $Items.add("$c=$d")
                }
                $Items | Out-File $global:inifile -enc ascii
            }
        } 
    }
 <#
    .SYNOPSIS
    Open and write to ini files
     
    .DESCRIPTION
     VDS
    inifile open $(evn windir)+'\win.ini'
    inifile write probably "don't do this"
    
    .LINK
    https://dialogshell.com/vds/help/inifile
 #>
 }
 
 function iniread($a,$b) {
    $Items = New-Object System.Collections.Generic.List[System.Object]
    $content = get-content $global:inifile
    if ($content) {
        $Items.AddRange($content)
    }
    if ($Items.indexof("[$a]") -eq -1) {
        $return = ""
    }
    else {
        $return = ""
        For ($i=$Items.indexof("[$a]")+1; $i -lt $Items.count; $i++) {
            if ($Items[$i].length -gt $b.length) {
                if ($Items[$i].substring(0,$b.length) -eq $b -and $gate -ne $true) {
                        $return = $Items[$i].split("=")[1]
                        $gate = $true
                }
            }
            if ($Items[$i].length -gt 0) {
                if (($Items[$i].substring(0,1) -eq "[") -and ($tgate -ne $true)) {
                    $gate = $true
                }
            }
        }
    }
    return $return
<#
    .SYNOPSIS
    Returns a read from a file specified by inifile open.
     
    .DESCRIPTION
     VDS
    console $(iniread content value)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/iniread
#>  
}
 
 function innertext ($a,$b,$c,$d) {
    $split1 = $a -Split $b
    $split2 = ($split1[1] | out-string) -Split $c
    if ($d){
        return ($split1[0]+$b+$d+$c | out-string)
    }
    else{
        return ($split2[0] | out-string).Trim()
    }
 <#
    .SYNOPSIS
    Returns the inner text of a body of text split by start text, and end text. If a fourth parameter is specified, returns the text with innertext replaced.
     
    .DESCRIPTION
     VDS
        $d = $(innertext 'abcdefg' 'bc' 'ef')
        
    .LINK
    https://dialogshell.com/vds/help/innertext
 #>
 }


function input($a,$b) {
    $input = [Microsoft.VisualBasic.Interaction]::InputBox($a,$b)
    return $input
<#
    .SYNOPSIS
    Produces a input dialog and returns the value.
     
    .DESCRIPTION
     VDS
    $input = $(input "Verify Address" "Verify Details")
     
    .LINK
    https://dialogshell.com/vds/help/index.php/input
#>  
} #partial implementation - Missing optional password parameter

function item($a) {
    return $a.SelectedItems
<#
    .SYNOPSIS
    Returns the selected item from a list
     
    .DESCRIPTION
     VDS
    $item = $(item $listbox1)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/item
#>  
}

function items($a) {
    return $a.SelectedItems
<#
    .SYNOPSIS
    Returns the selected items from a list
     
    .DESCRIPTION
     VDS
    $items = $(items $listbox1)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/items
#>
} #untested

function key($a) {
    return $(chr $(asc "{"))+$a+$(chr $(asc "}"))
<#
    .SYNOPSIS
    Useful with window send, works with special keys. Esc, Enter, Up, Down etc.
     
    .DESCRIPTION
     VDS
    window send $(winexists notepad) $(key up)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/key
#>
} 

function killtask ($a) {
    stop-process -name $a
 <#
    .SYNOPSIS
    Ends a task
     
    .DESCRIPTION
     VDS
    killtask explorer.exe
    
    .LINK
    https://dialogshell.com/vds/help/index.php/killtask
 #>
 }
 
 function len($a) {
    return $a.length
<#
    .SYNOPSIS
    Returns the length of a string
     
    .DESCRIPTION
     VDS
    $length = $(len $textbox1.text)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/len
#>
}

function lf {
    return chr(10)
<#
    .SYNOPSIS
    Returns a line feed
     
    .DESCRIPTION
     VDS
    $lf = $(lf)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/lf
#>
}

function like ($a,$b) {
    return $a -like $b
<#
    .SYNOPSIS
    Returns the one item is like another
     
    .DESCRIPTION
     VDS
    $like = $(string $(like 'string' 'string'))
     
    .LINK
    https://dialogshell.com/vds/help/index.php/like
#>
}

 function link ($a,$b,$c,$d,$e,$f,$g) {
    $Shell = New-Object -ComObject ("WScript.Shell")
    $ShortCut = $Shell.CreateShortcut($a)
    $ShortCut.TargetPath=$b
    $ShortCut.Arguments=$e
    $ShortCut.WorkingDirectory = $c
	if ($g -ne $null){
		$ShortCut.WindowStyle = ($g/1)
	}
	else {
		$ShortCut.WindowStyle = 1
	}
    $ShortCut.Hotkey = ""
    $ShortCut.IconLocation = $d
    $ShortCut.Save()
	
if ($f -eq $true) {
	$bytes = [System.IO.File]::ReadAllBytes($a)
	$bytes[0x15] = $bytes[0x15] -bor 0x20
	[System.IO.File]::WriteAllBytes($a, $bytes)
}
 <#
    .SYNOPSIS
    Creates a shortcut
     
    .DESCRIPTION
     VDS
    link c:\vds\explorer.lnk c:\windows\explorer.exe c:\windows c:\windows\explorer.exe 
    
    .LINK
    https://dialogshell.com/vds/help/index.php/link
 #>
 }

 function list ($a,$b,$c,$d) {
    switch ($a) {
	    add {
                $b.Items.Add($c) | Out-Null
		}
        append {
            $b.Items.AddRange($c.Split())
        }
        assign {
            $b.Items.AddRange($c.Items)
        }
        clear {
            $b.Items.Clear()
        }
		create{
		return New-Object System.Windows.Forms.listbox
		}
        copy {
            Set-Clipboard $b.items
        } 
        delete {
            $b.Items.RemoveAt($b.SelectedIndex)
        }
        insert {
            $b.items.Insert($b.SelectedIndex,$c)
        }
        paste {     
                $clip = Get-Clipboard
                $b.Items.AddRange($clip.Split())
            }
        put {
                $sel = $b.selectedIndex
                $b.Items.RemoveAt($b.SelectedIndex)
                $b.items.Insert($sel,$c)
            }
        reverse {
            $rev = [array]$b.items
            [array]::Reverse($rev)
            $b.items.clear()
            $b.items.AddRange($rev)
        }
        seek {
            $b.selectedIndex = $c
        }
        sort {
            $b.sorted = $true
        }
        dropfiles {
            if ($c.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
                foreach ($filename in $c.Data.GetData([Windows.Forms.DataFormats]::FileDrop)) {
                    list add $b $filename
                }
            }
        }#  list dropfiles $listbox1 $_
         # declare: $listbox1.AllowDrop = $true
         # Use $listbox1.add_DragEnter
        filelist {
            switch ($d) {
                dir {
                    $items = Get-ChildItem -Path $c
                    foreach ($item in $items) {
                        if ($item.Attributes -eq "Directory") {
                            list add $b $item
                        }
                    }
                }
                file {
                    $items = Get-ChildItem -Path $c
                    foreach ($item in $items) {
                        if ($item.Attributes -ne "Directory") {
                            list add $b $item
                        }
                    }
                }
            }
        }
        fontlist {  
            [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
            $r = (New-Object System.Drawing.Text.InstalledFontCollection).Families
            foreach ($s in $r){
                $b.items.AddRange($s.name)
            }
        }
        loadfile {
            $content = get-content $c
            $b.items.addrange($content)
        }
        loadtext {
            $b.items.addrange($c.Split([char][byte]10))
        }
        modules {
            $process = Get-Process $c -module
            foreach ($module in $process) {
                $b.items.Add($module) | Out-Null
            }
        }
        regkeys {
            $keys = Get-ChildItem -Path $c
            foreach ($key in $keys) {
                $b.items.add($key) | Out-Null
            }
        }
        
        regvals {
            #$name = Get-Item -Path $c | Select-Object -ExpandProperty Property | Out-String
            $name = $(out-string -inputobject $(select-object -inputobject $(get-item -path $c) -expandproperty property))
            $b.items.addrange($name.Split([char][byte]13))
        } 
        savefile {
        $b.items | Out-File $c
        }
        tasklist {
            $proc = Get-Process | Select-Object -ExpandProperty ProcessName | Out-String
            $b.items.addrange($proc.Split([char][byte]13))
        }
        winlist {
            $win = Get-Process | Where-Object {$_.MainWindowTitle -ne ""} | Select-Object -ExpandProperty MainWindowTitle | Out-String
            $b.items.addrange($win.Split([char][byte]13))
        }
    }
 <#
    .SYNOPSIS
    Performs list operations.
    add
    append
    assign
    clear
	create
    copy
    delete
    insert
    paste
    put
    reverse
    seek
    sort
    dropfiles
    filelist
        dir
        file
    fontlist
    loadfile
    loadtext
    modules
    regkeys
    regvals
    savefile
    tasklist
    winlist
     
    .DESCRIPTION
     VDS
    list add $list1 "item"
    list append $list1 $string
    list assign $list1 $list2
    list clear $list1
	$list1 = list create
    list copy $list1
    list delete $list1
    list insert $list1 $item
    list paste $list1
    list put $list1 $item
    list reverse $list1
    list seek $list1 5
    list sort $list1
    list dropfiles $list1 $_
        (Inside of your script, you must $list1.AllowDrop = $true; the event is $list1.add_DragEnter)
    list filelist $list1 c:\ dir
    list filelist $list1 c:\ file
    list fontlist $combobox1
    list loadfile $list1 c:\windows\win.ini
    list loadtext $list1 $string
    list modules $list1 explorer.exe
    list regkeys $list1 hkcu:\software\dialogshell
    list regvals $list1 hkcu:\software\dialogshell
    list savefile $list1 c:\vds\test.txt
    list tasklist $list1
    list winlist $list1
    
    .LINK
    https://dialogshell.com/vds/help/index.php/list
 #>
 }
 
 function loaddll ($a){
    if ($(substr $a 0 2) -eq 'ht') {
        $s = iwr $a
        return [Reflection.Assembly]::Load($s.content) | out-null
    }
    else {
        [Reflection.Assembly]::LoadFile($a) | Out-Null
    }
<#
    .SYNOPSIS
     Loads a dynamic link library
     
    .DESCRIPTION
     VDS
    loaddll c:\temp\dotnet.dll
    loaddll https://mydomain.com/dotnet.dll
    
    .LINK
    https://dialogshell.com/vds/help/index.php/loaddll
#>          
}
 
function lower($a) {
    return $a.ToLower()
<#
    .SYNOPSIS
    Returns the lower case string of a string
     
    .DESCRIPTION
     VDS
    $lower = $(lower $string)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/lower
#>
}

function match($a,$b,$c) {
    if ($c -eq $null){
        $c = -1
    }
    else {
        $c = $c
    }
    try{$return = $a.FindString($b,$c)}
    catch{$return = $a.Items.IndexOf($b)}
        return $return
<#
    .SYNOPSIS
    The index of the next match in a list, with an optional start point.
     
    .DESCRIPTION
     VDS
    $match = $(match $listbox1 $string 3)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/match
#>
}

function mod($a,$b) {
    return $a % $b
<#
    .SYNOPSIS
    Returns the modulo of dividend and divisor
     
    .DESCRIPTION
     VDS
    $mod = $(mod 60 30)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/mod
#>
}

 function modifyfonts ($a, $b) {
    switch ($a) {
        add {
            $shellapp =  New-Object -ComoObject Shell.Application
            $Fonts =  $shellapp.NameSpace(0x14)
            $Fonts.CopyHere($b)
        }
        remove {
            $name = Get-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' | Select-Object -ExpandProperty Property | Out-String
            #$name = $(out-string $(select-object $(get-item -path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts') -expandproperty property))
            $keys = $name.Split([char][byte]10)
            foreach ($key in $keys) {
                $key = $key.Trim()
                if ($(substr $key 0 ($b.length)) -eq $b) {
                    $file = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' -Name $key | Select -ExpandProperty $key
                    $file = $file.trim() 
                    Remove-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' -Name $key 
                }
            }
        }
    }
 <#
    .SYNOPSIS
    Adds or removes a font
     
    .DESCRIPTION
     VDS
    modifyfonts add $file
    modifyfonts remove $font-name
    
    .LINK
    https://dialogshell.com/vds/help/index.php/modifyfonts
 #>
 }

 function module ($a,$b,$c) {
    switch ($a){
        import {
            $Content = (get-content $b)
            $Content = resource asciidecode $Content
            return (string $Content)
        }
        export {
            $Content = (get-content $b)
            $exportstring = resource asciiencode $Content
            $exportstring | Out-File $c -enc ascii
        }
    }
 <#
    .SYNOPSIS
    Exports or imports  base64 encoded modules
     
    .DESCRIPTION
     VDS
    module export c:\vds\trunk\sum.psm1 c:\vds\trunk\sum.dll
    module import c:\vds\trunk\sum.dll | run
    
    .LINK
    https://dialogshell.com/vds/help/index.php/module
 #>
 }

function mousedown {
    return [System.Windows.Forms.UserControl]::MouseButtons | Out-String
<#
    .SYNOPSIS
    Returns the mousebutton that is pressed.
     
    .DESCRIPTION
    $mousedown = $(mousedown)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/mousedown
#>
} 

function mousepos($a) {
    switch ($a) {
        x {
            return [System.Windows.Forms.Cursor]::Position.X
        }
        y {
            return [System.Windows.Forms.Cursor]::Position.Y
        }
        xy {
        $x = [System.Windows.Forms.Cursor]::Position.X | Out-String
        $y = [System.Windows.Forms.Cursor]::Position.Y | Out-String
        return $x.Trim()+$fieldsep+$y.Trim()
        }
        yx {
        $x = [System.Windows.Forms.Cursor]::Position.X | Out-String
        $y = [System.Windows.Forms.Cursor]::Position.Y | Out-String
        return $y.Trim()+$fieldsep+$x.Trim()
        }
        default {
        $x = [System.Windows.Forms.Cursor]::Position.X | Out-String
        $y = [System.Windows.Forms.Cursor]::Position.Y | Out-String
        return $x.Trim()+$fieldsep+$y.Trim()
        }
    }
<#
    .SYNOPSIS
    Returns the mouse position as string with options being x, y, xy or yx. Defaults to xy.
     
    .DESCRIPTION
     VDS
    $mousepos = $(mousepos xy)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/mousepos
#>
} 

function msgbox($a,$b,$c,$d) {
    $msgbox = [System.Windows.Forms.MessageBox]::Show($a,$b,$c,$d)
    return $msgbox
<#
    .SYNOPSIS
    Generates a messagebox according to provided paramaters. 
    [param1 Message]
    [param2 Title]
    [param3 buttons, YesNo YesNoCancel OKCancel or OK]
    [param4 Icon, can be 0 (none) ,16 (Hand) ,32 (Question) ,48 (Warning) or 64 (Information)]
     
    .DESCRIPTION
     VDS
    $msgbox = $(msgbox 'Do we agree?' 'Question' 'YesNoCancel' 64)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/msgbox
#>  
} 

function name($a) {
    return [io.path]::GetFileNameWithoutExtension($a)
<#
    .SYNOPSIS
    Returns the file name without extension
     
    .DESCRIPTION
     VDS
    $name = $(name $file)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/name
#>
}

function next($a) {
    if ($a.items.count -gt $a.selectedIndex + 1) {
        $a.selectedIndex = $a.selectedIndex + 1
        return $a.selectedItems
    }
    else {
    return $false
    }
<#
    .SYNOPSIS
    Progresses a list to the next item.
     
    .DESCRIPTION
     VDS
    $next = $(next $listbox1)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/next
#>
}

function not($a){
    if ($a -eq $false) {
        return $true
    }
    else {
    return $false}
<#
    .SYNOPSIS
    Returns true if false
     
    .DESCRIPTION
     VDS
    if ($(not $(null $value)))
    {console "It ain't nothing"}
     
    .LINK
    https://dialogshell.com/vds/help/index.php/not
#>
}

function null($a) {
    if ($a -eq $null) {
        return $true
    }
    else {
        return $false
    }
<#
    .SYNOPSIS
    Returns true if null
     
    .DESCRIPTION
     VDS
    if ($(not $(null $value)))
    {console "It ain't nothing"}
     
    .LINK
    https://dialogshell.com/vds/help/index.php/null
#>
}

function numeric($a) {
    return $a -is [int]
<#
    .SYNOPSIS
    Returns true if numeric
     
    .DESCRIPTION
     VDS
    console $(numeric $isnumber)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/numeric
#>
}

function ok {
    return $?
<#
    .SYNOPSIS
    Returns true if OK.
     
    .DESCRIPTION
     VDS
    console $(ok)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/ok
#>
} 

function option ($a, $b, $c, $d) {
    switch ($a) {
        colordlg {
            switch ($b) {
                object {$global:colordlg = "object"}
                normal {$global:colordlg = "normal"}
            }
        }

        fieldsep {
            $global:fieldsep = $b
        }
	}
<#
    .SYNOPSIS
    Declares an application option, currently colordlg and fieldsep
     
    .DESCRIPTION
     VDS
    option colordlg object
    option fieldsep ":"
    
    .LINK
    https://dialogshell.com/vds/help/index.php/option
#>
}   

function parse ($a) {
    return $a.split($global:fieldsep)
<#
    .SYNOPSIS
    parses a string by fieldsep
     
    .DESCRIPTION
     VDS
    $parse = $(parse $string)
    info $parse[0]
    
    .LINK
    https://dialogshell.com/vds/help/index.php/parse
#>
}

function path($a) {
    return Split-Path -Path $a
<#
    .SYNOPSIS
    Returns the path of a file
     
    .DESCRIPTION
     VDS
    console $(path $file)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/path
#>
}

 function pineapples {
    start https://dialogshell.com/vds/help/index.php/Talk:Pineapples
 <#
    .SYNOPSIS
    Open a page to discuss pineapples
     
    .DESCRIPTION
     VDS
     pineapples
    
    .LINK
    https://dialogshell.com/vds/help/index.php/pineapples
 #>
 }

function play ($a, $b) {
    $PlayWav=New-Object System.Media.SoundPlayer
    $PlayWav.SoundLocation=$a
    if ($b -eq "wait") {
        $PlayWav.playsync()
    }
    else {
        $PlayWav.play()
    }
<#
    .SYNOPSIS
    Plays a sound
     
    .DESCRIPTION
     VDS
    play my.wav wait
    play my.wav
    
    .LINK
    https://dialogshell.com/vds/help/index.php/play
#>
}

function pos($a,$b) {
    $regEx = [regex]$a
    $pos = $regEx.Match($b)
    if ($pos.Success){ 
        return $pos.Index
    }
    else {
        return false
    }
<#
    .SYNOPSIS
    Returns the position of [param1] in [param2]
     
    .DESCRIPTION
     VDS
    console $(pos b brandon)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/pos
#>
} #partial implementation - missing 'exact'

function pred($a) {
    return $a - 1
<#
    .SYNOPSIS
    Returns the predecessor of number
     
    .DESCRIPTION
     VDS
    list seek $listbox1 $(pred $(index $listbox1))
    
    .LINK
    https://dialogshell.com/vds/help/index.php/pred
#>
}

function presentation($a,$b,$c,$d,$e,$f,$g,$h,$i){
    switch ($a){
        create {

        $xaml = @"
            <Window
                    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
                    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
                    Title="$b" Height="$g" Width="$f">
                    <Grid Name="$c">
                    </Grid>
            </Window>
"@
            $MainWindow = (presentation $xaml)
            return $MainWindow
        }
        add {
            $control = new-object System.Windows.Controls.$c
            $control.Content = "$h"
            $b.Children.Insert($b.Children.Count, $control)
            $control.VerticalAlignment = "Top"
            $control.HorizontalAlignment = "Left"
            $control.Margin = "$e,$d,0,0"
            $control.Height = "$g"
            $control.Width = "$f"
            return $control
        }
        insert {
        $control = new-object System.Windows.Controls.$c
        $b.Children.Insert($b.Children.Count, $control)
        return $control
        }
        findname {
        return $b.FindName($c)
        }
        valign { $b.VerticalAlignment = $c
        }
        align { $b.HorizontalAlignment = $c
        }
        content { $b.Content = $c}
        margin {$b.Margin = $c}
        height {$b.Height = $c}
        width {$b.Width = $c}
        navigationwindow {
        $Xaml = @"
            <NavigationWindow xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Name = "NavWindow" Width = "600" Height = "400" WindowStartupLocation = "CenterScreen" ResizeMode = "CanMinimize" ></NavigationWindow>
"@
$wind = presentation page $Xaml
if ($b)
{$wind.Content = (presentation page $b)}
return $wind
        }
        page {
            $b = $b -replace 'd:DesignHeight="\d*?"', '' -replace 'x:Class=".*?"', '' -replace 'mc:Ignorable="d"', '' -replace 'd:DesignWidth="\d*?"', '' 
            [xml]$b = $b
            $presentation = [Windows.Markup.XamlReader]::Load((new-object System.Xml.XmlNodeReader $b))
            $b.SelectNodes("//*[@Name]") | %{
                Set-Variable -Name $_.Name.ToString() -Value $presentation.FindName($_.Name) -Scope global
            }
        return $presentation
        }
        window {
            $b = $b -replace "x:N", 'N' -replace 'd:DesignHeight="\d*?"', '' -replace 'x:Class=".*?"', '' -replace 'mc:Ignorable="d"', '' -replace 'd:DesignWidth="\d*?"', '' 
            [xml]$b = $b
            $presentation = [Windows.Markup.XamlReader]::Load((new-object System.Xml.XmlNodeReader $b))
            $b.SelectNodes("//*[@Name]") | %{
                Set-Variable -Name $_.Name.ToString() -Value $presentation.FindName($_.Name) -Scope global
            }
        return $presentation
        }
        explicit {
        [xml]$a = $a
            $presentation = [Windows.Markup.XamlReader]::Load((new-object System.Xml.XmlNodeReader $a))
            return $presentation
        }
        strict {
            [xml]$a = $a
            $presentation = [Windows.Markup.XamlReader]::Load((new-object System.Xml.XmlNodeReader $a))
            $a.SelectNodes("//*[@Name]") | %{
                Set-Variable -Name $_.Name.ToString() -Value $presentation.FindName($_.Name) -Scope global
            }
        return $presentation
        }
        default {
            $a = $a -replace "x:N", 'N' -replace 'd:DesignHeight="\d*?"', '' -replace 'x:Class=".*?"', '' -replace 'mc:Ignorable="d"', '' -replace 'd:DesignWidth="\d*?"', '' 
            [xml]$a = $a
            $presentation = [Windows.Markup.XamlReader]::Load((new-object System.Xml.XmlNodeReader $a))
            $a.SelectNodes("//*[@Name]") | %{
                Set-Variable -Name $_.Name.ToString() -Value $presentation.FindName($_.Name) -Scope global
            }
        return $presentation
        }
    }
<#
    .SYNOPSIS
    Creates a Windows Foundation Presentation window or page form and elements within.
     
    .DESCRIPTION
     VDS
     $presentation  = presentation create "Admin Calculator" calc 0 0 148 229
        #dynamically create window on the fly, like a winform
     $ButtonCE = presentation add $calc Button 30 5 30 30 "CE"  
     
     $ButtonCE = presentation insert $calc Button
        #insert into existing grid
        
    $calc = presentation findname $presentation calc
        #return the presentation object with the name specfied from the presentation object specfied
     
     presentation valign $button1 "Top"
     presentation align $button1 "center"
     
     presentation content $page2
        #where page2 is a wpf page
    
    presentation margin $button1 10
    presentation height $button1 40
    presentation width $button1 120
    
    presentation navigationwindow $page2
        #where page2 is a presentation page
        #parses names and filters XAML.
    
    $pres = presentation page $page2
    
    $presentation = presentation window $page1
        #parses names and filters XAML.
    
    $presentation = presentation explicit $page1
        #Doesn't parse names, and XAML must be powershell ready.
        
    $presentation = presentation strict $page1
        #Parses names, but assumes XAML is powershell ready.
    
    $presentation = presentation $page1
        #see presentation window.
        
    .LINK
    https://dialogshell.com/vds/help/index.php/Presentation
#>
}

function prod($a) {
    return $a + 1
<#
    .SYNOPSIS
    Returns the prodecessor of number
     
    .DESCRIPTION
     VDS
    list seek $listbox1 $(prod $(index $listbox1))
    
    .LINK
    https://dialogshell.com/vds/help/index.php/prod
#>
}

function property ($a,$b,$c) {
    if ($c) {
        $a.$b = $c
    }
    else {
    return $a.$b
    }
<#
    .SYNOPSIS
    Sets a property
     
    .DESCRIPTION
     VDS
    property $text text "text"
    
    .LINK
    https://dialogshell.com/vds/help/index.php/property
#>
}

function query($a,$b) {
    $query = [System.Windows.Forms.MessageBox]::Show($a,$b,"OKCancel",32)
    return $query
<#
    .SYNOPSIS
    Generates an OK Cancel dialog and returns the result.
     
    .DESCRIPTION
     VDS
    $question = $(query "Is it Monday?" "Select Day")
    
    .LINK
    https://dialogshell.com/vds/help/index.php/query
#>
} 

function random($a,$b) {
    if ($b) {
        return Get-Random -Minimum $a -Maximum $b
    }
    else {
        get-random -SetSeed $a
    }
<#
    .SYNOPSIS
    Generates a random number, or sets the random seed.
     
    .DESCRIPTION
     VDS
    random 123456 #seed
    $roll = $(random 1 100) #random number
    
    .LINK
    https://dialogshell.com/vds/help/index.php/random
#>
}

function regexists($a,$b) {
    $return = Get-ItemProperty -Path $a -Name $b
    if ($return) {
    return $true
    }
    else {
    return $false
    }
<#
    .SYNOPSIS
    Returns true if the registry path exists
     
    .DESCRIPTION
     VDS
    console $(regexists hkcu:\software\dialogshell)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/regexists
#>
}

function registry ($a, $b, $c, $d, $e) {
    switch ($a) {
        copykey {
            Copy-Item -Path $b -Destination $c
        }
        deletekey {
            Remove-Item -Path $b -Recurse
        }
        movekey {
            Copy-Item -Path $b -Destination $c
            Remove-Item -Path $b -Recurse
        }
        renamekey {
            Rename-Item -Path $b -NewName $c
        }
        newkey {
            New-Item -Path $b -Name $c
        }
        newitem {
            New-ItemProperty -Path $b -Name $c -PropertyType $d -Value $e
        }
        modifyitem {
            Set-ItemProperty -Path $b -Name $c -Value $d
        }
        renameitem {    
            Rename-ItemProperty -Path $b -Name $c -NewName $d
        }
        deleteitem {    
            Remove-ItemProperty -Path $b -Name $c
        }
    }
<#
    .SYNOPSIS
    Performs registry operations
    copykey
    deletekey
    movekey
    renamekey
    newitem
    modifyitem
    renameitem
    deleteitem
     
    .DESCRIPTION
     VDS
    registry copykey hkcu:\software\dialogshell hklm:\software\dialogshell
    registry deletekey hkcu:\software\dialogshell
    registry movekey hkcu:\software\dialogshell hklm:\software\dialogshell
    registry renamekey hkcu:\software\dialogshell visualdialogshell
    registry newitem 
    
    .LINK
    https://dialogshell.com/vds/help/index.php/registry
#>
}

function regread($a,$b) {
    return Get-ItemProperty -Path $a -Name $b | Select -ExpandProperty $b
<#
    .SYNOPSIS
    Returns the value of a registry entry
     
    .DESCRIPTION
     VDS
    $regread = $(regread hkcu:\software\dialogshell window)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/regread
#>
} #partial implementation - path names are slightly different, $a is path with a : in it, $b is property. No default return. 

function regtype($a,$b) {
    switch ((Get-ItemProperty -Path $a -Name $b).$b.gettype().Name){ 
        "String" {
            return "REG_SZ"
        }
        "Int32" {
        return "REG_DWORD"
        }
        "Int64" {
        return "REG_QWORD"
        }
        "String[]" {
        return "REG_MULTI_SZ"
        }
        "Byte[]" {
        return "REG_BINARY"
        } 
        default {
        return "Unknown type"
        }
    }
<#
    .SYNOPSIS
    Returns the type of value from a registry entry
     
    .DESCRIPTION
     VDS
    $regtype = $(regtype hkcu:\software\dialogshell window)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/regtype
#>
} #partial implementation

function rem {
<#
    .SYNOPSIS
    Comment
     
    .DESCRIPTION
     VDS
    rem This will not be executed.  
    
    .LINK
    https://dialogshell.com/vds/help/index.php/rem
#>
} #This is done.
function resource ($a,$b,$c) {
    switch ($a)
    {
        load {
            return [Byte[]](resource decode (get-content $b))
        }
        import{
            $import = [System.IO.File]::ReadAllBytes($b)
            return [System.Convert]::ToBase64String($import)
        }
        export{
            $export = [System.Convert]::FromBase64String($b)
            [System.IO.File]::WriteAllBytes($c,$export)
        }
        asciiencode{
            $enc = [system.Text.Encoding]::ASCII
            return [System.Convert]::ToBase64String($enc.GetBytes($b))
        }
        asciidecode{
            $decode = [System.Convert]::FromBase64String($b)
            return [System.Text.Encoding]::ASCII.GetString($decode)
        }
        decode {
        return [System.Convert]::FromBase64String($b)
        #although this works, it returns a system object, which is not usable. We need raw. Not sure how to fix.
        }
    }
<#
    .SYNOPSIS
    Comment
     
    .DESCRIPTION
     VDS
    
    $resource = resource load .\resource.res
        #imports and decodes a base64 encoded file
    
    $resource = resource import .\resource.ico
        #import a resource directly from file, imports to base64
    
    resource export $resource .\resource.res
        #Exports a resource to a base64 encoded file
        
    $encode = resource asciiencode "this string"
    
    $decode = resource asciidecode "dGhpcyBzdHJpbmc="
    
    $decode = resource decode $resrouce #not working yet I think
    
    .LINK
    https://dialogshell.com/vds/help/index.php/resource
#>
}

function retcode() {
return $LASTEXITCODE
<#
    .SYNOPSIS
    Returns the last exit code
     
    .DESCRIPTION
     VDS
    console $(retcode)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/retcode
#>
}

function savedlg($a,$b,$c){
    $filedlg = New-Object System.Windows.Forms.SaveFileDialog
    $filedlg.initialDirectory = $b
    $filedlg.filter = $a
    $filedlg.ShowDialog() | Out-Null
    return $filedlg.FileName 
<#
    .SYNOPSIS
    Returns the results of a file selection dialog.
     
    .DESCRIPTION
     VDS
    $save = $(saveedlg 'Text Files|*.txt' $(windir)) 
     
    .LINK
    https://dialogshell.com/vds/help/index.php/savedlg
#>  
}

function screeninfo($a) {
	switch ($a) {
	height{[System.Windows.Forms.SystemInformation]::VirtualScreen.height}
	width {[System.Windows.Forms.SystemInformation]::VirtualScreen.width}
	scale {return $ctscale}
	}
}

function selected($a) {
    return CountRows($a.SelectedItems)
<#
    .SYNOPSIS
    Returns the number of list items selected
     
    .DESCRIPTION
     VDS
    $selected = $(selected $listbox1)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/selected
#>
}

function selenium ($a,$b,$c,$d) {
    switch ($a){
        reference {
            $env:PATH += ";$b"
            Add-Type -Path ($b + 'WebDriver.dll')
            $ChromeOptions = New-Object OpenQA.Selenium.Chrome.ChromeOptions
            $ChromeOptions.AddAdditionalCapability("useAutomationExtension", $false)
            $global:selenium = New-Object OpenQA.Selenium.Chrome.ChromeDriver($ChromeOptions)
        }
        open {
            $global:selenium.Navigate().GoToURL($b) 
        }
        get {
            return $global:selenium.FindElementsByXPath("//*[contains(@$b, '$c')]")
        }
        set {
            $global:selenium.FindElementsByXPath("//*[contains(@$b, '$c')]").SendKeys($d)
        }
        click {
            $global:selenium.FindElementsByXPath("//*[contains(@$b, '$c')]").Click()
        }
        stop {
            $global:selenium.Close()
            $global:selenium.Quit()
            Get-Process -Name chromedriver -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue
        }
    }
<#
    .SYNOPSIS
    Requires webdriver.dll and chromedriver.exe for qa of google chrome
     
    .DESCRIPTION
     VDS
    selenium reference 'c:\temp\psl\'
    selenium open 'http://google.com'
    $value = $(selenium get 'id' 'Text1')
    selenium set 'id' 'Text1' 'new value'
    selenium click 'id' 'button1'
    selenium stop
    
    .LINK
    https://dialogshell.com/vds/help/index.php/selenium
#>
}

function sendmsg($a,$b,$c,$d) {
    [vds]::SendMessage($a, $b, $c, $d)
<#
    .SYNOPSIS
    See SendMessage Win32 API
    https://docs.microsoft.com/en-us/windows/desktop/api/winuser/nf-winuser-sendmessage
     
    .DESCRIPTION
     VDS
    $currentrow = $(sendmsg $(winexists $RichEdit) 0x00c1 $RichEdit.SelectionStart 0)
     
    .LINK
    https://dialogshell.com/vds/help/index.php/sendmsg
#>
}

function server ($a,$b,$c){
    switch ($a) {
        start {
            $vdsServer = New-Object Net.HttpListener
            $server = $b + ':' + $c + '/'
            $vdsServer.Prefixes.Add($server)
            $vdsServer.Start()
            return $vdsServer
        }
        watch {
            $event = $b.GetContext()
            return $event
        }
        context {
            return $b.Request.Url.LocalPath
        }
        return {
            $buffer = [System.Text.Encoding]::ASCII.GetBytes($c)
            $b.Response.ContentLength64 = (len $buffer)
            $b.Response.OutputStream.Write($buffer, 0, (len $buffer))
            $b.Response.Close()
        }
        stop {
            $b.Stop()
        }
    }
<#
    .SYNOPSIS
    Controls web server transactions
     
    .DESCRIPTION
     VDS
    $vdsServer = server start http://localhost:2323
    $event = (server watch $vdsServer)
    if(equal (server context $event) "/")
    server return $event $return
    server stop $vdsServer
    
    .LINK
    https://dialogshell.com/vds/help/index.php/server
#>
}

function shell($a,$b) {
        $shell = new-object -com shell.application
        $f = $shell.NameSpace($(path $b))
        $file = $f.ParseName(($(name $b))+'.'+($(ext $b)))
        $file.Verbs() | %{if($_.Name -eq $a) { $_.DoIt() }}
<#
    .SYNOPSIS
    Peforms a shell operation on a file
     
    .DESCRIPTION
     VDS
    shell "&Print" c:\windows\win.ini
    
    .LINK
    https://dialogshell.com/vds/help/index.php/shell
#>
}

function shift($a) {
return "+$a"
<#
    .SYNOPSIS
     Sends the SHIFT key plus string. Only useful with 'window send'.
     
    .DESCRIPTION
     VDS
    window send $(winexists notepad) $(shift "s")
    
    .LINK
    https://dialogshell.com/vds/help/index.php/shift
#>
} 

function shortname {
    [cmdletbinding()]
    Param([Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)][array]$Path)
    If ($(Get-Item $Path).PSIsContainer -eq $true) {
        $SFSO = New-Object -ComObject Scripting.FileSystemObject
        $short = $SFSO.GetFolder($($Path)).ShortPath
    } 
    Else {
        $SFSO = New-Object -ComObject Scripting.FileSystemObject
        $short = $SFSO.GetFile($($Path)).ShortPath
    }
    return $short
<#
    .SYNOPSIS
     Returns the 8.3 shortname of a file
     
    .DESCRIPTION
     VDS
    $shortname = $(shortname $file)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/shortname
#>
}

function stop {
    Exit-PSSession
<#
    .SYNOPSIS
    Exits the script and ends the program.
     
    .DESCRIPTION
     VDS
    stop
    
    .LINK
    https://dialogshell.com/vds/help/index.php/stop
#>
}

function strdel($a,$b,$c) {
    return ($a.substring(0,$b)+$(substr $a $c $a.length))
<#
    .SYNOPSIS
     Returns the string without start index to end index.
     
    .DESCRIPTION
     VDS
    $string = $(strdel $string 8 16)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/strdel
#>
}

function streamimage ($a){
    $s = iwr $a
    $r = New-Object IO.MemoryStream($s.content, 0, $s.content.Length)
    $r.Write($s.content, 0, $s.content.Length)
    return [System.Drawing.Image]::FromStream($r, $true)
<#
    .SYNOPSIS
     Creates a image from a web url stream
     
    .DESCRIPTION
     VDS
    $PictureBox1.image = $(streamimage 'https://dialogshell.com/eternium.png')
    
    .LINK
    https://dialogshell.com/vds/help/index.php/streamimage
#>          
}

function string($a) {
return ($a | Out-String).trim()
#Proper form for dialogshell philosophy if splitting hairs: return $(trim $(Out-String -inputobject $a)) . Were it written before the trim function, ($(Out-String -inputobject $a)).Trim() . I don't feel we as a community should care, and this code is written and produces the expected output - so the point is moot. No one should touch this.

#Powershell proper form, which I really don't care about. It's ineffeicient and hard to remember. Feel free to write in this form, just don't expect me to.

<#
function string {
    [CmdletBinding()]
    param(
        [Parameter(Position=0,mandatory=$true)]
        [string] $InputString)
        ($InputString | Out-String).Trim()
}
#>
#You'll notice proper powershell didn't include a return keyword, this is actually correct. I include the return keyword to discern a VDS function from a VDS command when I'm looking at the Powershell function without proper context.
#Expect me to be annoyed if you ask for help with a VDS function, and there is no return keyword, because I'll think I'm helping with a VDS command.
#Some keywords have both command and function form, like console. You'll notice the VDS function form of the keyword has a return statement.
<#
    .SYNOPSIS
     Converts a value to string.
     
    .DESCRIPTION
     VDS
    $string = $(string $value)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/string
#>
}

function substr($a,$b,$c) {
    return $a.substring($b,($c-$b))
<#
    .SYNOPSIS
     Gets the value of a string between a start index and a end index
     
    .DESCRIPTION
     VDS
    $string = $(substr $string 3 6)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/substr
#>
}

function succ($a) {
    return $a + 1
<#
    .SYNOPSIS
     Adds one to a value.
     
    .DESCRIPTION
     VDS
    $increase = $(succ $number)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/succ
#>
}

function sum($a,$b) {
    return $a + $b
<#
    .SYNOPSIS
     Adds two values.
     
    .DESCRIPTION
     VDS
    $total = $(sum $num1 $num2)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/sum
#>
} #partial implementation - only accepts two params

function sysinfo($a) {
    switch ($a) {
        freemem {
            $return = Get-WmiObject Win32_OperatingSystem | fl FreePhysicalMemory | Out-String
            return $return.split(':')[1].Trim() 
        } 
        pixperin {
        return $(regread 'hkcu:\Control Panel\Desktop\WindowMetrics' 'AppliedDpi')
        } 
        screenheight {
            foreach ($screen in [system.windows.forms.screen]::AllScreens) {
                if ($screen.primary) {
                    return $screen.Bounds.Height
                }
            }
        }
        screenwidth {
            foreach ($screen in [system.windows.forms.screen]::AllScreens) {
                if ($screen.primary) {
                    return $screen.Bounds.Width
                }
            }
        }    
        winver {
            $major = [System.Environment]::OSVersion.Version | Select-Object -expandproperty Major | Out-String
            $minor = [System.Environment]::OSVersion.Version | Select-Object -expandproperty Minor | Out-String
            $build = [System.Environment]::OSVersion.Version | Select-Object -expandproperty Build | Out-String
            $revision = [System.Environment]::OSVersion.Version | Select-Object -expandproperty Revision | Out-String
            return $major.Trim()+'.'+$minor.Trim()+'.'+$build.Trim()+'.'+$revision.Trim()
        } 
        win32 {
            return ([IntPtr]::size * 8)
        } 
        psver {
            $major = $psversiontable.psversion.major | Out-String
            $minor = $psversiontable.psversion.minor | Out-String
            $build = $psversiontable.psversion.build | Out-String
            $revision = $psversiontable.psversion.revision | Out-String
            return $major.Trim()+'.'+$minor.Trim()+'.'+$build.Trim()+'.'+$revision.Trim() 
        } 
        dsver {
        return '0.3.2.0'
        }
        winboot {
            $return = Get-CimInstance -ClassName win32_operatingsystem | fl lastbootuptime | Out-String
            $return = $return.split('e')[1].Trim()
            $return = $(substr $return 2 $(len $return))
            return $return
        }
        screenrect {
            $z = '0'
            $sw = $(sysinfo screenwidth) | Out-String
            $sh = $(sysinfo screenheight) | Out-String
            return $z+$fieldsep+$z+$fieldsep+$sw.Trim()+$fieldsep+$sh.Trim()
        }
        language {
            return GET-WinSystemLocale |Select-Object -expandproperty DisplayName
        }
    }
<#
    .SYNOPSIS
     Returns information about the system according to parameter.
     Available parameters: freemem, pixperin, screenwidth, winver, win32, psver, dsver, winboot, screenrect, language
     
    .DESCRIPTION
    $syinfo = $(sysinfo screenrect)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/sysinfo
#>
}

function tab {
    return "`t" 
<#
    .SYNOPSIS
    Returns the tab character, useful with window send
     
    .DESCRIPTION
     VDS
    window send $(winexists notepad) $(tab)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/tab
#>
} 

function taskbar ($a) {
    $hWnd = [vds]::FindWindowByClass("Shell_TrayWnd")
    switch ($a) {
        show {
            [vds]::ShowWindow($hWnd, "SW_SHOW_DEFAULT")
        }
        hide {
            [vds]::ShowWindow($hWnd, "SW_HIDE")
        }
    }
<#
    .SYNOPSIS
    Shows or hides the taskbar
     
    .DESCRIPTION
     VDS
    taskbar show
    taskbar hide
    
    .LINK
    https://dialogshell.com/vds/help/index.php/taskbar
#>
}

function text ($a) {
    return [array]$a.items | Out-String
<#
    .SYNOPSIS
    Returns the entire text of a list
     
    .DESCRIPTION
     VDS
    $text = $(text $listbox1)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/text
#>
} 

function the ($a,$b,$c) { #supports option "of" for $b
    if ($(null $c)) {
        return $b.$a
    }
    else {
    return $c.$a
    }
<#
    .SYNOPSIS
    Language element, represents the property of object.
     
    .DESCRIPTION
     VDS
    foreach($row in $(the Rows of $mElemetnsGrid)){}
    
    .LINK
    https://dialogshell.com/vds/help/index.php/the
#>
}

function timer($a) {
    $timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = $a
    $timer.Enabled = $true
    return $timer
<#
    .SYNOPSIS
    Creates a timer which has a tick event at a specified interval.
     
    .DESCRIPTION
     VDS
    $timer = timer 1000
    $timer.add_Tick({})
    
    .LINK
    https://dialogshell.com/vds/help/index.php/timer
#>
}
function title ($a,$b) {
    $a.text = $b
<#
    .SYNOPSIS
    Sets the title of a dialog window
     
    .DESCRIPTION
     VDS
    title $MyForm "New Title"
    
    .LINK
    https://dialogshell.com/vds/help/index.php/title
#>
}

function trace ($a) {
    switch ($a) {
            on {
                Set-PSDebug -Trace 1
            }
            off {
                Set-PSDebug -Trace 0
            }
        }
<#
    .SYNOPSIS
    Debugs output to the console window, valid switches are on and off.
     
    .DESCRIPTION
     VDS
    trace on
    
    .LINK
    https://dialogshell.com/vds/help/index.php/trace
#>
}

function trim ($a) {
    return $a.Trim()
<#
    .SYNOPSIS
    Returns the trim of a string
     
    .DESCRIPTION
     VDS
    $trimStr = $(trim $string)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/trim
#>
} 

function unequal($a, $b) {
    if ($a -eq $b) {
        return $false
    } 
    else {
        return $true
    }
<#
    .SYNOPSIS
    Returns true if two values are not equal
     
    .DESCRIPTION
     VDS
    $testEq = $(unequal $val1 $val2)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/unequal
#>
}

function unzip($a,$b)
{
    Expand-Archive -LiteralPath $a -DestinationPath $b -force
<#
    .SYNOPSIS
    Decompresses a folder to folder
     
    .DESCRIPTION
     VDS
    unzip c:\temp\window.zip c:\temp\window 
    
    .LINK
    https://dialogshell.com/vds/help/index.php/zero
#>
}

function upper($a) {
    return $a.ToUpper()
<#
    .SYNOPSIS
    Returns the string in uppercase
     
    .DESCRIPTION
     VDS
    $upperonly = $(upper $string)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/upper
#>
}

function val($a) {
    return $a
<#
    .SYNOPSIS
    Does nothing. Returns what's sent.
     
    .DESCRIPTION
     VDS
    $val = $(val 42)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/val
#>
} 

function vkey($a){
    switch($a)
    {
        None{return 0}
        Alt{return 1}
        Control{return 2}
        Shift{return 4}
        WinKey{return 8}
        LBUTTON{return 0x01}
        RBUTTON{return 0x02}
        CANCEL{return 0x03}
        MBUTTON{return 0x04}
        XBUTTON1{return 0x05}
        XBUTTON2{return 0x06}
        BACK{return 0x08}
        TAB{return 0x09}
        CLEAR{return 0x0C}
        RETURN{return 0x0D}
        SHIFT{return 0x10}
        CONTROL{return 0x11}
        MENU{return 0x12}
        PAUSE{return 0x13}
        CAPITAL{return 0x14}
        KANA{return 0x15}
        HANGUEL{return 0x15}
        HANGUL{return 0x15}
        IME_ON{return 0x16}
        JUNJA{return 0x17}
        FINAL{return 0x18}
        HANJA{return 0x19}
        KANJI{return 0x19}
        IME_OFF{return 0x1A}
        ESCAPE{return 0x1B}
        CONVERT{return 0x1C}
        NONCONVERT{return 0x1D}
        ACCEPT{return 0x1E}
        MODECHANGE{return 0x1F}
        SPACE{return 0x20}
        PRIOR{return 0x21}
        NEXT{return 0x22}
        END{return 0x23}
        HOME{return 0x24}
        LEFT{return 0x25}
        UP{return 0x26}
        RIGHT{return 0x27}
        DOWN{return 0x28}
        SELECT{return 0x29}
        PRINT{return 0x2A}
        EXECUTE{return 0x2B}
        SNAPSHOT{return 0x2C}
        INSERT{return 0x2D}
        DELETE{return 0x2E}
        HELP{return 0x2F}
        0{return 0x31}
        1{return 0x32}
        3{return 0x34}
        4{return 0x35}
        6{return 0x36}
        7{return 0x37}
        8{return 0x38}
        9{return 0x39}
        A{return 0x41}
        B{return 0x42}
        C{return 0x43}
        D{return 0x44}
        E{return 0x45}
        F{return 0x46}
        G{return 0x47}
        H{return 0x48}
        I{return 0x49}
        J{return 0x4A}
        K{return 0x4B}
        L{return 0x4C}
        M{return 0x4D}
        N{return 0x4E}
        O{return 0x4F}
        P{return 0x50}
        Q{return 0x51}
        R{return 0x52}
        S{return 0x53}
        T{return 0x54}
        U{return 0x55}
        V{return 0x56}
        W{return 0x57}
        X{return 0x58}
        Y{return 0x59}
        Z{return 0x5A}
        LWIN{return 0x5B}
        RWIN{return 0x5C}
        APPS{return 0x5D}
        SLEEP{return 0x5F}
        NUMPAD0{return 0x60}
        NUMPAD1{return 0x61}
        NUMPAD2{return 0x62}
        NUMPAD3{return 0x63}
        NUMPAD4{return 0x64}
        NUMPAD5{return 0x65}
        NUMPAD6{return 0x66}
        NUMPAD7{return 0x67}
        NUMPAD8{return 0x68}
        NUMPAD9{return 0x69}
        MULTIPLY{return 0x6A}
        ADD{return 0x6B}
        SEPARATOR{return 0x6C}
        SUBTRACT{return 0x6D}
        DECIMAL{return 0x6E}
        DIVIDE{return 0x6F}
        F1{return 0x70}
        F2{return 0x71}
        F3{return 0x72}
        F4{return 0x73}
        F5{return 0x74}
        F6{return 0x75}
        F7{return 0x76}
        F8{return 0x77}
        F9{return 0x78}
        F10{return 0x79}
        F11{return 0x7A}
        F12{return 0x7B}
        F13{return 0x7C}
        F14{return 0x7D}
        F15{return 0x7E}
        F16{return 0x7F}
        F17{return 0x80}
        F18{return 0x81}
        F19{return 0x82}
        F20{return 0x83}
        F21{return 0x84}
        F22{return 0x85}
        F23{return 0x86}
        F24{return 0x87}
        NUMLOCK{return 0x90}
        SCROLL{return 0x91}
        LSHIFT{return 0xA0}
        RSHIFT{return 0xA1}
        LCONTROL{return 0xA2}
        RCONTROL{return 0xA3}
        LMENU{return 0xA4}
        RMENU{return 0xA5}
        BROWSER_BACK{return 0xA6}
        BROWSER_FORWARD{return 0xA7}
        BROWSER_REFRESH{return 0xA8}
        BROWSER_STOP{return 0xA9}
        BROWSER_SEARCH{return 0xAA}
        BROWSER_FAVORITES{return 0xAB}
        BROWSER_HOME{return 0xAC}
        VOLUME_MUTE{return 0xAD}
        VOLUME_DOWN{return 0xAE}
        VOLUME_UP{return 0xAF}
        MEDIA_NEXT_TRACK{return 0xB0}
        MEDIA_PREV_TRACK{return 0xB1}
        MEDIA_STOP{return 0xB2}
        MEDIA_PLAY_PAUSE{return 0xB3}
        LAUNCH_MAIL{return 0xB4}
        LAUNCH_MEDIA_SELECT{return 0xB5}
        LAUNCH_APP1{return 0xB6}
        LAUNCH_APP2{return 0xB7}
        OEM_1{return 0xBA}
        OEM_PLUS{return 0xBB}
        OEM_COMMA{return 0xBC}
        OEM_MINUS{return 0xBD}
        OEM_PERIOD{return 0xBE}
        OEM_2{return 0xBF}
        OEM_3{return 0xC0}
        OEM_4{return 0xDB}
        OEM_5{return 0xDC}
        OEM_6{return 0xDD}
        OEM_7{return 0xDE}
        OEM_8{return 0xDF}
        OEM_102{return 0xE2}
        PROCESSKEY{return 0xE5}
        PACKET{return 0xE7}
        ATTN{return 0xF6}
        CRSEL{return 0xF7}
        EXSEL{return 0xF8}
        EREOF{return 0xF9}
        PLAY{return 0xFA}
        ZOOM{return 0xFB}
        NONAME{return 0xFC}
        PA1{return 0xFD}
        OEM_CLEAR{return 0xFE}
    }
<#
    .SYNOPSIS
    Only useful with Hotkey function as a parameter.
     
    .DESCRIPTION
     VDS
    Virtual Key
    
    .LINK
    https://dialogshell.com/vds/help/index.php/vkey
#>
}

function volinfo($a,$b) {
    switch ($b) {
        F {
            return get-volume $a | Select-Object -expandproperty SizeRemaining
        }
        N { 
            return get-volume $a | Select-Object -expandproperty FriendlyName
        }
        S {
            return get-volume $a | Select-Object -expandproperty Size
        }
        T {
            return get-volume $a | Select-Object -expandproperty DriveType
        }
        Y {
            return get-volume $a | Select-Object -expandproperty FileSystemType
        }
        Z {
            return get-partition -driveletter $a | Get-Disk | Select-Object -expandproperty SerialNumber
        }
    }
<#
    .SYNOPSIS
    Does nothing. Returns what's sent.
     
    .DESCRIPTION
     VDS
    $val = $(val 42)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/volinfo
#>  
} 


function wait ($a) {
    if ($a -eq $null) {
        $a = 1
    }
    start-sleep -m (($a/1) * 1000) | Out-Null
<#
    .SYNOPSIS
    Pauses script execution in seconds, which may be fractional.
     
    .DESCRIPTION
     VDS
    wait .1 # 1/10th of 1 second
    
    .LINK
    https://dialogshell.com/vds/help/index.php/wait
#>
}

function warn ($a,$b) {
    [System.Windows.Forms.MessageBox]::Show($a,$b,'OK',48)
<#
    .SYNOPSIS
    Displays a warning message with title to the end user
     
    .DESCRIPTION
     VDS
    warn "Cannot complete action err $err" "Processing error..." 
    
    .LINK
    https://dialogshell.com/vds/help/index.php/warn
#>
}

function webExec($a)
{
    invoke-expression (iwr -uri $a -UseDefaultCredentials)
<#
    .SYNOPSIS
    CAUTION: Executes code directly from URI seemlessly. WARNING: Review code first. RISK: Be very careful. LIABILITY: I'm not.
     
    .DESCRIPTION
     VDS
    webExec https://raw.githubusercontent.com/brandoncomputer/vds/master/vds.psm1
    
    .LINK
    https://dialogshell.com/vds/help/index.php/webexec
#>  
}

function winactive($a) {
    return [vds]::GetForegroundWindow()
<#
    .SYNOPSIS
    Returns the active window handle
     
    .DESCRIPTION
     VDS
    $activewin = $(winactive)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/winactive
#>
}  

function winatpoint($a,$b) {
    $p = new-object system.drawing.point($a,$b)
    $return = [vds]::WindowFromPoint($p)
    return $return;
    #}
<#
    .SYNOPSIS
    Returns the window handle at x y
     
    .DESCRIPTION
     VDS
    $windowatxy = $(winatpoint 32 64)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/winatpoint
#>
}

function winchild($a){
return [vds]::GetWindow($a, 5)
<#
    .SYNOPSIS
    Returns the first child in a window.
     
    .DESCRIPTION
     VDS
    $child = $(winchild 345689)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/winparent
#>
}

function winclass($a) {
    $stringbuilt = New-Object System.Text.StringBuilder 256
    $that = [vds]::GetClassName($a, $stringbuilt, 256)
    return $($stringbuilt.ToString())
<#
    .SYNOPSIS
    Returns the window class by handle
     
    .DESCRIPTION
     VDS
    $class = $(winclass $(winexists "Untitled - Notepad"))
    
    .LINK
    https://dialogshell.com/vds/help/index.php/winclass
#>
} 

function windir($a) {
    return $(env windir)
<#
    .SYNOPSIS
    Returns the windows directory
     
    .DESCRIPTION
     VDS
    $windows = $(windir)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/windir
#>
}

function window ($a,$b,$c,$d,$e,$f) {
    switch ($a) {
        activate {
            [vds]::SetForegroundWindow($b)
        }
        click {
            window activate $b
            $x = $c + ($(winpos $b L))
            $y = $d + ($(winpos $b T))
            [vds]::LeftClickAtPoint($x,$y,[System.Windows.Forms.Screen]::PrimaryScreen.bounds.width,[System.Windows.Forms.Screen]::PrimaryScreen.bounds.height) | out-null
        }
        close {
            $(sendmsg $b 0x0112 0xF060 0)
        }
        flash {
            [Window]::FlashWindow($b,150,10)
        }
        fuse {
            [vds]::SetParent($b,$c)
        } 
        hide {
            [vds]::ShowWindow($b, "SW_HIDE")
        }
        iconize {
            [vds]::ShowWindow($b, "SW_MINIMIZE")
        }
        maximize {
            [vds]::ShowWindow($b, "SW_MAXIMIZE")
        }
        position {
        [vds]::MoveWindow($b,$c,$d,$e,$f,$true)
        }       
        rclick {
            window activate $b
            $x = $c + ($(winpos $b L))
            $y = $d + ($(winpos $b T))
            [vds]::RightClickAtPoint($x,$y,[System.Windows.Forms.Screen]::PrimaryScreen.bounds.width,[System.Windows.Forms.Screen]::PrimaryScreen.bounds.height) | out-null
        }       
        normal {
            [vds]::ShowWindow($b, "SW_SHOW_NORMAL")
        }
        ontop {
            [vds]::SetWindowPos($b, -1, $(winpos $b T), $(winpos $b L), $(winpos $b W), $(winpos $b H), 0x0040) | out-null
        }
        notontop {
            [vds]::SetWindowPos($b, -2, $(winpos $b T), $(winpos $b L), $(winpos $b W), $(winpos $b H), 0x0040) | out-null
        }
        send {
            window activate $b
            $wshell = New-Object -ComObject wscript.shell
            $wshell.SendKeys("$c")
        }
        settext {
            [vds]::SetWindowText($b,$c)
        }
    }
<#
    .SYNOPSIS
    Performs operations on displayed windows per parameter
    activate
    click
    close
    flash
    fuse
    hide
    iconize
    maximize
    position
    rclick
    normal
    ontop
    send
    settext
     
    .DESCRIPTION
     VDS
    window activate $(winexists notepad)
    window click $(winexists notepad) 15 15
    window close $(winxists notepad)
    window flash $(winexists notepad)
    window fuse $(winexists notepad) $(winexists $MyForm)
    window hide $(winexists notepad)
    window iconize $(winexists notepad)
    window maximize $(winexists notepad)
    window position $(winexists notepad) 15 15 200 200
    window rclick $(winexists notepad) 15 15
    window normal $(winexists notepad)
    window ontop $(winexists notepad)
    window send $(winexists notepad) "Notepad window"
    
    .LINK
    https://dialogshell.com/vds/help/index.php/window
#>
}

function winexists($a) {
    $class = [vds]::FindWindowByClass($a)
    if ($class) {
        return $class/1
    }
    else {
        $title = [vds]::FindWindowByTitle($a)
        if ($title){
            return $title/1
        }
        else {
            if ($a.handle) {
                return $a.handle
            }
        }   
    }
<#
    .SYNOPSIS
    Returns the handle of a window by class, title or $object
     
    .DESCRIPTION
     VDS
    $notepadopen = $(winexists notepad)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/winexists
#>
} 

function winparent($a){
return [vds]::GetParent($a)
<#
    .SYNOPSIS
    Returns the parent handle of a handle.
     
    .DESCRIPTION
     VDS
    $parent = $(winparent 345689)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/winparent
#>
}

function winpos($a,$b) {
    $Rect = New-Object RECT
    [vds]::GetWindowRect($a,[ref]$Rect) | Out-Null
    switch ($b)
    {
        T {
            return $Rect.Top
        }
        L {
            return $Rect.Left
        }
        W {
            return $Rect.Right - $Rect.Left
        }
        'H' {
        return $Rect.Bottom - $Rect.Top
        }
    }
<#
    .SYNOPSIS
    Returns a position element of a window by paramater
    Available parameters: T, L, W, H (Top, Left, Width, Height)
     
    .DESCRIPTION
     VDS
    $wintop = $(winpos $(winactive) T)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/winpos
#>
}

function keyPress($a,$b){
	[vds]::keybd_event($a,0,0,[UIntPtr]::new(0))
	wait $b
	[vds]::keybd_event($a,0,2,[UIntPtr]::new(0))
	<#
    .SYNOPSIS
	Presses and holds a vkey for a set amount of time.
     
    .DESCRIPTION
     VDS
    keyPress vkey(Q) 5
    
    .LINK
    https://dialogshell.com/vds/help/index.php/Keypress
#>
}

function invertWindow($a) {
    $Rect = New-Object RECT
    $Rect.Top = 0
    $Rect.Left = 0
    $Rect.Right = (($(winpos $a W)) + ($(winpos $a L)))
    $Rect.Bottom = (($(winpos $a H)) + ($(winpos $a T)))
    [vds]::InvertRect($x,[ref]$Rect)

<#
    .SYNOPSIS
	Inverts the colors of a window until the next redraw.
     
    .DESCRIPTION
     VDS
    invertwindow $(winexists 'windows powershell')
    
    .LINK
    https://dialogshell.com/vds/help/index.php/InvertWindow
#>
}

function winsibling($a){
return [vds]::GetWindow($a, 2)
<#
    .SYNOPSIS
    Returns the sibling of a window.
     
    .DESCRIPTION
     VDS
    $thirdBrother = $(winsibling $(winsibling $(winsibling $(winchild 345689))))
    
    .LINK
    https://dialogshell.com/vds/help/index.php/winparent
#>
}

function wintext($a) {
    $strbld = [vds]::GetWindowTextLength($a)
    $stringbuilt = New-Object System.Text.StringBuilder $strbld+1
    $that = [vds]::GetWindowText($a, $stringbuilt, $strbld+1)
    return $($stringbuilt.ToString())
<#
    .SYNOPSIS
    Returns the text of a window
     
    .DESCRIPTION
     VDS
    $Stext = $(wintext $(winactive))
    
    .LINK
    https://dialogshell.com/vds/help/index.php/wintext
#>
}

function xml($a,$b,$c,$d,$e){
    $nodeindex = 0
    switch ($a){
        insert{        #xml insert $doc.xml.Section 'brandname' 'BE=bottom,status=2'
            try{
                $b.$c.ForEach({$nodeindex++
                })
                $nodeindexest = $b.$c[$nodeindex - 1].Clone()
                    
                foreach ($split in $d.Split(",")) {
                        $innersplit = $split.split("=")
                        $i1 = $innersplit[0]
                        $i2 = $innersplit[1]
                        $nodeindexest.$i1 = $i2
                }
                $b.InsertAfter($nodeindexest,$b.$c[$nodeindex - 1])
        
            }
       
            catch{
                $nodeindexest = $b.$c.Clone()
                foreach ($split in $d.Split(",")) {
                        $innersplit = $split.split("=")
                        $i1 = $innersplit[0]
                        $i2 = $innersplit[1]
                        $nodeindexest.$i1 = $i2
                }
                $b.InsertBefore($nodeindexest,$b.$c[$nodeindex - 1])
            }
            
        }
        remove{
            try{
                $b.ForEach({
                $ver = ""
                foreach ($split in $c.Split(",")) {
                    $innersplit = $split.split("=")
                    if ($ver -eq ""){
                        $i1 = $innersplit[0]
                        $i2 = $innersplit[1]
                        $ver = $_.$i1 -eq $i2
                    }
                    else {
                        $i1 = $innersplit[0]
                        $i2 = $innersplit[1]
                        $ver = $ver -and $_.$i1 -eq $i2
                    }    
                }
                if ($ver) {$_.ParentNode.RemoveChild($_)}
                })
                                     

            }
            catch{
            $doit = $true
                foreach ($split in $c.Split(",")) {
                    $innersplit = $split.split("=")
                        $i1 = $innersplit[0]
                        $i2 = $innersplit[1]
                        if ($b.$i1 -eq $i2 -and $doit -eq $true)
                        {$doit = $true}else{$doit = $false} 
                }
                if ($doit -eq $true){$b.ParentNode.RemoveChild($b)}
            }
        
        }
        modify{
            try{
                $b.ForEach({
                    $doit = $true
                    foreach ($split in $c.Split(",")) {
                        $innersplit = $split.split("=")
                        $i1 = $innersplit[0]
                        $i2 = $innersplit[1]
                        if ($_.$i1 -eq $i2 -and $doit -eq $true)
                        {$doit = $true}else{$doit = $false} 
                }
                if ($doit -eq $true){$_.$d = $e}



                }) 
            }
            catch{
            $doit = $true
                foreach ($split in $c.Split(",")) {
                    $innersplit = $split.split("=")
                        $i1 = $innersplit[0]
                        $i2 = $innersplit[1]
                        if ($b.$i1 -eq $i2 -and $doit -eq $true)
                        {$doit = $true}else{$doit = $false} 
                }
                if ($doit -eq $true){$b.$d = $e}
            }
        }
        get{
            try{
            $t = ""
                $x = 0

                $b.ForEach({
                    $_.$c
                    $x = $x+1
                })

                $t = 0..($x -1)
                $x = 0
                $b.ForEach({
                    $t[$x] = $_.$c
                    $x = $x+1
                })
                return $t
            }
            catch{
                return $b.$c
            }
        }
        true{
            $n = 0
            
            foreach($p in $b){
                $n++
            }
          
            $t = 0..[int](($n / 2)-1)
            $i = 0
            foreach ($y in $t){
                $t[$i] = $b[$i]
                $i++
            }
            return $t
        }
    }
    <#
    .SYNOPSIS
    Performs xml operations: insert, remove, modify, get, true(get)
     
    .DESCRIPTION
     VDS
    True is present due to double return on get function, and it trues it up.

    xml insert $doc.xml.Section 'brandname' 'BE=bottom,status=2'
    xml modify $doc.xml.section.brandname 'BE=hi,status=1' 'BE' 'Bye'
    xml remove $doc.xml.section.brandname 'BE=hi,status=1'
    xml true $(xml get $doc.xml.section.brandname BE)

    .LINK
    https://dialogshell.com/vds/help/index.php/Directory
#> 
}

function zero($a) {
    if ($a -eq 0) {
        return $true
    } 
    else {
    return $false
    }
<#
    .SYNOPSIS
    Returns $true if a value is zero
     
    .DESCRIPTION
     VDS
    $test = $(zero $num)
    
    .LINK
    https://dialogshell.com/vds/help/index.php/zero
#>
}

function zip($a,$b,$c)
{
    switch ($a){
        update{
        compress-archive -path $b -update -destinationpath $c
        }
        default{
        compress-archive -path $a -destinationpath $b
        }
    }
<#
    .SYNOPSIS
    Compresses a folder or updates a compressed folder.
     
    .DESCRIPTION
     VDS
    zip c:\temp\window c:\temp\window.zip
    zip update c:\temp\window c:\window.zip
    
    .LINK
    https://dialogshell.com/vds/help/index.php/zero
#>
}

$path = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $path
[Environment]::CurrentDirectory = $path

$ErrorActionPreference = "SilentlyContinue"
$global:findregtabs = 0..100
$global:replaceregtabs = 0..100

if ($(regread "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell\"  "InstallLocation")){
directory change "$(regread "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell\"  "InstallLocation")\examples"
}
else{
directory change (path $host.ui.RawUI.WindowTitle)
}
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

if ($(not $(file [Environment]::GetFolderPath("MyDocuments")+"\DialogShell"))) {
    directory create ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell")
    directory create ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell\examples")
    directory create ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell\examples\en-US")
    directory create ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell\res")
    directory create ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell\elements")
    file copy ("$(regread "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell\" "InstallLocation")\res\*") ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell\res")
    file copy ("$(regread "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell\" "InstallLocation")\elements\*") ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell\elements")
    file copy ("$(regread "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell\" "InstallLocation")\examples\*.ds1") ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell\examples")
    file copy ("$(regread "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell\" "InstallLocation")\examples\*.mdb") ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell\examples")
    file copy ("$(regread "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell\" "InstallLocation")\examples\en-US\*") ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell\examples\en-US")
    $items = Get-ChildItem -Path ([Environment]::GetFolderPath("MyDocuments")+"\DialogShell\examples")
    foreach ($item in $items) { 
        if ($(trim $(ext $(string $item))) -eq 'ds1') {
           $item.FullName | Out-File [Environment]::GetFolderPath("MyDocuments")+"\DialogShell\$(name $item.FullName).dsproj" 
        }
    }
}

$global:popuprtf = $true

$global:designribbon = $false

    $global:var

$examplepath = [Environment]::GetFolderPath("MyDocuments")+"\DialogShell\examples"
$wizardpath = [Environment]::GetFolderPath("MyDocuments")+"\DialogShell\wizards"
if ($(file "c:\vds\trunk\plugins")){
$plugins = "c:\vds\trunk\plugins"}
else
{$plugins = "$(curdir)\..\plugins"}
$docpath = [Environment]::GetFolderPath("MyDocuments")+"\DialogShell"
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
if ($(file("$(regread "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell\" "InstallLocation")\examples\FastColoredTextBox.dll")))
{[Reflection.Assembly]::LoadFile("$(regread "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell\" "InstallLocation")\examples\FastColoredTextBox.dll") | Out-Null}
else
{[Reflection.Assembly]::LoadFile("$(curdir)\FastColoredTextBox.dll") | out-null
}

$script:lastfind = ""
$script:curdoc = ""


$btscale = 1

#$global:ctscale = ($screen/$vscreen)

$FastTextForm       = dialog create "Visual DialogShell" 0 0 600 480
$FastTextForm.Font = New-Object System.Drawing.Font("Calibri",8)
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


$file               = dialog add $FastTextForm menustrip "$localefile" ("$localenew|Ctrl+N|$(curdir)\..\res\page_add.png,$localeopen|Ctrl+O|$(curdir)\..\res\folder_page_white.png,$localesave|Ctrl+S|$(curdir)\..\res\disk.png,$localesaveas,-,$localeprint|Ctrl+P|$(curdir)\..\res\printer.png,-,E&xit")
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
        
      <#   run (get-content "'$(curdir)\..\DialogShell Designer.ds1'") | out-string
          $inv = "'$(curdir)\..\DialogShell Designer.exe'"
        run "&" $inv" #>
		if ($ctscale -eq 1)
		{
		
$global:eleOK = "true"

if ($global:dd -eq "false")
{
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
		else{info "Screen Scale must be 100%. Please adjust your monitor in windows settings and relaunch the IDE to continue."}
        }
   "$localecompile" {
       cls

            if (file ((path $FastTab.SelectedTab.Text)+'\'+$(name $FastTab.SelectedTab.Text)+'.pil'))
            {
                start-process -filepath C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -argumentlist '-ep bypass','-windowstyle hidden','-sta',"-file $(chr 34)$(curdir)\..\compile\compile-gui.ps1$(chr 34) $(chr 34)$(path $FastTab.SelectedTab.Text)\$(name $FastTab.SelectedTab.Text).pil$(chr 34) $(chr 34)$(curdir)\..\compile$(chr 34)"

            }
            else {
                if ($FastTab.SelectedTab.Text -ne "[$localenewtt]") {
                    if ($FastTab.TabPages.Count -gt 0) {
                        inifile open ((path $FastTab.SelectedTab.Text)+'\'+(name $FastTab.SelectedTab.Text)+'.pil')
                        inifile write compile inputfile $FastTab.SelectedTab.Text
                        inifile write compile outputfile ((path $FastTab.SelectedTab.Text)+'\'+(name $FastTab.SelectedTab.Text)+'.cmd')
                start-process -filepath C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -argumentlist '-ep bypass','-windowstyle hidden','-sta',"-file $(chr 34)$(curdir)\..\compile\compile-gui.ps1$(chr 34) $(chr 34)$(path $FastTab.SelectedTab.Text)\$(name $FastTab.SelectedTab.Text).pil$(chr 34) $(chr 34)$(curdir)\..\compile$(chr 34)"

                    }
                    else { 
                    start-process -filepath C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -argumentlist '-ep bypass','-windowstyle hidden','-sta',"-file $(chr 34)$(curdir)\..\compile\compile-gui.ps1$(chr 34)"
                    }
                }
                else {
                 start-process -filepath C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -argumentlist '-ep bypass','-windowstyle hidden','-sta',"-file $(chr 34)$(curdir)\..\compile\compile-gui.ps1$(chr 34)"
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
start-process -filepath C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -argumentlist '-ep bypass','-sta',"-file $(chr 34)$curdir\..\compile\dialogshell.ps1$(chr 34)"
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
             start-process -filepath C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -argumentlist '-ep bypass','-sta',"-file $(chr 34)$curdir\..\compile\dialogshell.ps1$(chr 34) $(chr 34)$(string $FastTab.SelectedTab.Text)$(chr 34) -cpath"

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
        "E&xit" {
            while ($FastTab.TabPages.Count -gt 0) {
                if ($FastTab.SelectedTab.Controls[0].IsChanged -eq $true){
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
            dialog close $FastTextForm
            }
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
    $mFooterString = ''
    $mFooterString2 = ''
    $ms = $false
    $ts = $false
    $mExportString+= $mFormXTextBox2.Text+' = dialog create "'+$mFormGroupBox.Text+'" 0 0 '+$mFormGroupBox.Width+' '+$mFormGroupBox.Height+'
    ' 
    
    foreach ($row in $FormPropertiesGrid.Rows)
{
if ($row.Cells[1].Value -ne $null){
if ($row.Cells[1].Value -ne "") {
$mExportString+='dialog property '+$mFormXTextBox2.Text+' '+($row.Cells[0].Value) +' "'+($row.Cells[1].Value)+'"
' 
 }
 }}
    
    foreach ($mElement in $mFormObj.Elements){ 
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
    $FastTab.SelectedTab.Controls[0].InsertText($mExportString)
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


{$mform.icon = '..\res\icon.ico'
}
else{
    $dir = string $(regread "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell" "InstallLocation")
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
 
$mFormLabel = dialog add $mform label 5 5 40 " " 'Title:'
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
$openform = $mFormList.selecteditem
            $mFormObj.Elements = Import-Clixml $openform
            inifile open $openform
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
$FormPropertiesGrid.Rows.Add("HelpButton",$(iniread Form HelpButton))
$FormPropertiesGrid.Rows.Add("HorizontalScroll",$(iniread Form HorizontalScroll))
$FormPropertiesGrid.Rows.Add("Icon",$(iniread Form Icon))
$FormPropertiesGrid.Rows.Add("IsMdiChild",$(iniread Form IsMdiChild))
$FormPropertiesGrid.Rows.Add("IsMdiContainer",$(iniread Form IsMdiContainer))
$FormPropertiesGrid.Rows.Add("IsRestrictedWindow",$(iniread Form IsRestrictedWindow))
$FormPropertiesGrid.Rows.Add("KeyPreview",$(iniread Form KeyPreview))
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
$FormPropertiesGrid.Rows.Add("TopLevel",$(iniread Form TopLevel))
$FormPropertiesGrid.Rows.Add("TopLevelControl",$(iniread Form TopLevelControl))
$FormPropertiesGrid.Rows.Add("TopMost",$(iniread Form TopMost))
$FormPropertiesGrid.Rows.Add("TransparencyKey",$(iniread Form TransparencyKey))
$FormPropertiesGrid.Rows.Add("UseWaitCursor",$(iniread Form UseWaitCursor))
$FormPropertiesGrid.Rows.Add("VerticalScroll",$(iniread Form VerticalScroll))
$FormPropertiesGrid.Rows.Add("Visible",$(iniread Form Visible))
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
    $openform = filedlg("DialogShell Form|*.dsform")
        if ($openform){
                 $find = $mFormList.FindString($openform)
                 if ($find -eq -1){
                 $mFormList.items.Add($openform)}
                list clear $mAssignList
                list assign $mAssignList $mFormList
            $mFormObj.Elements = Import-Clixml $openform
            inifile open $openform
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
$FormPropertiesGrid.Rows.Add("HelpButton",$(iniread Form HelpButton))
$FormPropertiesGrid.Rows.Add("HorizontalScroll",$(iniread Form HorizontalScroll))
$FormPropertiesGrid.Rows.Add("Icon",$(iniread Form Icon))
$FormPropertiesGrid.Rows.Add("IsMdiChild",$(iniread Form IsMdiChild))
$FormPropertiesGrid.Rows.Add("IsMdiContainer",$(iniread Form IsMdiContainer))
$FormPropertiesGrid.Rows.Add("IsRestrictedWindow",$(iniread Form IsRestrictedWindow))
$FormPropertiesGrid.Rows.Add("KeyPreview",$(iniread Form KeyPreview))
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
$FormPropertiesGrid.Rows.Add("TopLevel",$(iniread Form TopLevel))
$FormPropertiesGrid.Rows.Add("TopLevelControl",$(iniread Form TopLevelControl))
$FormPropertiesGrid.Rows.Add("TopMost",$(iniread Form TopMost))
$FormPropertiesGrid.Rows.Add("TransparencyKey",$(iniread Form TransparencyKey))
$FormPropertiesGrid.Rows.Add("UseWaitCursor",$(iniread Form UseWaitCursor))
$FormPropertiesGrid.Rows.Add("VerticalScroll",$(iniread Form VerticalScroll))
$FormPropertiesGrid.Rows.Add("Visible",$(iniread Form Visible))
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
    $dir = string $(regread "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell" "InstallLocation")
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
            'Top'   {} 
            'Left'  {}  
            'Width' {} 
            'Height' {} 
             'Text'  {}

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
                $dir = string $(regread "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\DialogShell" "InstallLocation")
                 $psr = -join($dir,"\Elements")
                $mWebBrowser1.Navigate($psr)
           
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


