
    

Add-Type -AssemblyName System.Windows.Forms,System.Drawing

    $Form = New-Object System.Windows.Forms.Form
    $Form.Text="Form"
    $Form.Width = 600
	$Form.Height = 480
    

        $Button1 = New-Object System.Windows.Forms.Button
					$Button1.Text="Button1"
					$Button1.Width="75"
					$Button1.Height="23"
					$Button1.Top="82"
					$Button1.Left="44"
        $Form.Controls.Add($Button1)
        

        $DataGrid1 = New-Object System.Windows.Forms.DataGridView
					$DataGrid1.Text="DataGrid1"
					$DataGrid1.Width="130"
					$DataGrid1.Height="80"
					$DataGrid1.Top="100"
					$DataGrid1.Left="159"
        $Form.Controls.Add($DataGrid1)
        [System.Windows.Forms.Application]::Run($Form) | Out-Null