$path = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $path
[Environment]::CurrentDirectory = $path
$host.ui.RawUI.Backgroundcolor = 1
cls
console "DialogShell $(sysinfo dsver)"
console "Open Source - vds/pwsh community."
$host.ui.RawUI.WindowTitle = "DialogShell $(sysinfo dsver)"
if ($args[0] -ne $null) {
	if ($args[1] -eq "-cpath") {
		directory change $(path $args[0])
	}
	invoke-expression $(get-content $args[0] | Out-String)
}
else
{while (1){
Write-Host 'DS' $(curdir)'>' -NoNewLine
invoke-expression $Host.UI.ReadLine()
}}