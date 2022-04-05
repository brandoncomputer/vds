$script:curdoc = ""
$xaml = @"

    
<Window x:Class="WpfApp2.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp2"
        mc:Ignorable="d"
        Title="RichEdit WPF" Height="450" Width="800">

    <Grid ShowGridLines="true">

        <Menu x:Name="menu" VerticalAlignment="Top" Height="24">
            <MenuItem Name="File" Height="24" Width="32" Header="File">
            <MenuItem Header="New" Name="New"/>
            <MenuItem Header="Open" Name="Open"/>
            <MenuItem Header="Save" Name="Save"/>
            <MenuItem Header="Save As" Name="SaveAs"/>
            </MenuItem>
        </Menu>
        <ToolBar x:Name="toolBar" Height="24" VerticalAlignment="top" Margin="0,24,0,0">
        <Button x:Name="NewButton" Width="18" Height="18" FlowDirection="RightToLeft" Padding="0" BorderThickness="0">
                <Button.Foreground>
                    <ImageBrush ImageSource="https://dialogshell.com/vds-bin/res/page_add.png"/>
                </Button.Foreground>
                <Button.Background>
                    <ImageBrush ImageSource="https://dialogshell.com/vds-bin/res/page_add.png"/>
                </Button.Background>
            </Button>
        </ToolBar>
        <ScrollViewer Margin="0,48,0,0">
        <RichTextBox x:Name="RichEdit" Margin="0,0,0,0">
                <FlowDocument>
                    <Paragraph>
                        <InlineUIContainer>

                        </InlineUIContainer>
                    </Paragraph>
                </FlowDocument>
            </RichTextBox>
        </ScrollViewer>
    </Grid>
</Window>
"@ 

$RichEditForm = (presentation $xaml)

$NewButton.UseLayoutRounding = $false
$NewButton.OverridesDefaultStyle = $True

$NewButton.add_Click({      $RichEdit.Document.Blocks.Clear()
                $RichEditForm.Title = "RichEdit WPF"})
$New.add_Click({
                $RichEdit.Document.Blocks.Clear()
                dialog set $RichEditForm "RichEdit"
   
        })
            
            $NewButton.add_MouseMove({
                
                #$NewButton.UpdateLayout()
               $NewButton.BackGround.ImageSource = "file:///c:/vds/trunk/res/page_add.png"
               #after several hours of trying to fix the mouseover, I gave up. I just simply don't know WPF well enough.
        })

$Open.add_Click({
$fileOpen = $(filedlg "Rich Documents|*.rtf")
            if ($fileOpen) {
            $RichEdit.SelectAll()
                $Content = get-content $fileOpen
$ascii = (new-Object System.Text.ASCIIEncoding).getbytes($Content)
$stream = new-Object System.IO.MemoryStream($ascii,$false)
$RichEdit.Selection.Load($stream, [Windows.DataFormats]::Rtf) 
$stream.Close()
            }
})
        
$SaveAs.add_Click({            
    $saveFile = $(savedlg "Rich Documents|*.rtf")
            if ($saveFile) {
                $RichEdit.SelectAll()
    $as = New-Object IO.FileStream $saveFile ,'Create'
               $a = $RichEdit.Selection.Save($as,[Windows.DataFormats]::Rtf)
$as.Close()
            }})
                    

dialog showmodal $RichEditForm