import-module c:\vds\trunk\vds.psm1
$browser    = dialog create WebBrowser 0 0 800 600
$back       = dialog add $browser button 0 0 64 64
$forward    = dialog add $browser button 0 64 64 64
$reload     = dialog add $browser button 0 128 64 64
$homex      = dialog add $browser button 0 192 64 64
$url        = dialog add $browser textbox 0 256 64 64
$box        = dialog add $browser webbrowser 64 0 256 256

registry newitem "HKCU:\Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION\" "vdsbrowser.exe" DWord 11001
registry newitem "HKCU:\Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION\" "dialogshell.exe" DWord 11001

$box.GoHome()

$url.Font = 'Segoe UI, 32pt, style=Bold, Italic'

$browser.MinimumSize = new-object System.Drawing.Size(800,600)

dialog backgroundimage $back ..\res\back.png
dialog backgroundimage $forward ..\res\forward.png
dialog backgroundimage $reload ..\res\o.png
dialog backgroundimage $homex ..\res\home.png

$back.flatstyle     = 1
$forward.flatstyle  = 1
$reload.flatstyle   = 1
$homex.flatstyle    = 1

$back.BackGroundImageLayout     = 'stretch'
$forward.BackGroundImageLayout  = 'stretch'
$reload.BackGroundImageLayout   = 'stretch'
$homex.BackGroundImageLayout    = 'stretch'

$timer = timer 1000
$timer.add_Tick({dialog title $browser $box.document.title
})

$timerURL = timer 100
$timerURL.add_Tick({
$url.text = $box.document.url
})

$browser.add_Resize({
    $url.width = $browser.width - 280
$box.height = $browser.height - 112
$box.width = $browser.width - 24
})

$browser.add_Load({
$url.width = $browser.width - 280
$box.height = $browser.height - 112
$box.width = $browser.width - 24
})

$back.add_Click({
    $box.GoBack()
})

$forward.add_Click({
    $box.GoForward()
(dlgprops $box) | Out-file .\box.txt
})

$homex.add_Click({
$box.GoHome()
})

$reload.add_Click({
$box.Refresh()
})


$url.add_KeyDown({
    $timerURL.enabled = $false
    if ($_.keycode -eq "Enter") {
    $box.navigate($url.text)
    $timerURL.enabled = $true
    }
})

$url.add_Click({
    $url.SelectAll()
    $timerURL.enabled = $false
})
$box.add_NewWindow({param($sender,$e)
    $box.Navigate($box.StatusText)
$e.Cancel = $true
})

dialog show $browser