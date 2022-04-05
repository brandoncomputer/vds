$xaml = @"
<Window x:Class="WpfApp1.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp1"
        mc:Ignorable="d"
        Title="MainWindow" Height="350" Width="525">
        <Grid Name="presentation">
    <StackPanel x:Name="root" VerticalAlignment="Center" HorizontalAlignment="Center">
        <StackPanel.Resources>
            <Style TargetType="{x:Type Button}">
                <Setter Property="Height" Value="20"/>
                <Setter Property="Width" Value="250"/>
                <Setter Property="HorizontalAlignment" Value="Left"/>
            </Style>
        </StackPanel.Resources>
        <TextBlock Name="text1">Start by clicking the button below</TextBlock>
        <Button Name="b1">Make new button and add handler to it</Button>
    </StackPanel>
    </Grid>
</Window>
"@ 

$MainWindow = (presentation $xaml)

$b1.add_Click({
    dialog set $text1 "Now click the second button....."
$b1.IsEnabled = $false

$b2 = presentation insert $root button
presentation content $b2 "New Button"

$b2.add_Click({dialog set $text1 "New Button was clicked"})
})
dialog showmodal $MainWindow