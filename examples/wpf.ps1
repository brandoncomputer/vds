$xaml = @"
<Window x:Class="WpfApp1.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp1"
        mc:Ignorable="d"
        Title="MainWindow" Height="450" Width="800">
    <Grid RenderTransformOrigin="0.5,0.5">
        <Grid.RenderTransform>
            <TransformGroup>
                <ScaleTransform/>
                <SkewTransform/>
                <RotateTransform Angle="-34.983"/>
                <TranslateTransform/>
            </TransformGroup>
        </Grid.RenderTransform>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="277*"/>
            <ColumnDefinition Width="119*"/>
        </Grid.ColumnDefinitions>
        <Button x:Name="button" Content="Button" HorizontalAlignment="Left" Margin="58,118,0,0" VerticalAlignment="Top" Width="75"/>
        <Calendar HorizontalAlignment="Left" Margin="333,118,0,0" VerticalAlignment="Top"/>
        <CheckBox x:Name="checkBox" Content="CheckBox" HorizontalAlignment="Left" Margin="162,234,0,0" VerticalAlignment="Top" Height="52"/>

    </Grid>
</Window>

"@ 

$presentation = (presentation $xaml)
wait 1
$Button1.add_Click({info "Hello World"})
$Button2.add_Click({info "Only One!"})
dialog showmodal $presentation