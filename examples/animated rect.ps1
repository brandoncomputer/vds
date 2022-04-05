$page = @"
<Page xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" 
      xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
      WindowTitle="Animate Height"
>

<!-- default.xaml
*
* This Sample shows a Rectangle Element with Gradient Fill and an Animated Height
*
-->
  <DockPanel>

    <!-- Create a Rectangle -->

    <Rectangle Width="200" Height="200" Name="myRectangle">

      <!-- Set the Rectangle's Fill Property with a LinearGradientBrush -->
      <Rectangle.Fill>
        <LinearGradientBrush StartPoint="0,0" SpreadMethod="Pad" EndPoint="0,1" MappingMode="RelativeToBoundingBox">
          <LinearGradientBrush.GradientStops>
            <GradientStopCollection>
             <GradientStop Offset="0" Color="red" />
             <GradientStop Offset="0.5" Color="green" />
             <GradientStop Offset="0.9074074" Color="blue" />
            </GradientStopCollection>
          </LinearGradientBrush.GradientStops>
        </LinearGradientBrush>
      </Rectangle.Fill>
    </Rectangle>
      
    <DockPanel.Triggers>
     <EventTrigger RoutedEvent="Page.Loaded"> 
       <BeginStoryboard Name="myBeginStoryboard">
         <Storyboard Name="myStoryboard">
           <DoubleAnimation Storyboard.TargetName="myRectangle" Storyboard.TargetProperty="(Rectangle.Height)" 
            From="0" To="100" 
            RepeatBehavior="0:0:50" BeginTime="0:0:0.5" />
           <DoubleAnimation Storyboard.TargetName="myRectangle" Storyboard.TargetProperty="(Rectangle.Height)"
            From="0" To="100" AutoReverse="true" RepeatBehavior="0:0:50" BeginTime="0:0:0.5" Duration="0:0:2"/>
         </Storyboard>
       </BeginStoryboard>
     </EventTrigger>
    </DockPanel.Triggers>
  </DockPanel>            
            
</Page>
"@

$page2 = @"
<Page xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" 
  xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
  x:Class="Microsoft.Samples.Animation.StoryboardsExample" 
  WindowTitle="Storyboards Example">
  <StackPanel Margin="20">
    
  <Rectangle Name="MyRectangle" Width="100" Height="100">
      <Rectangle.Fill>
        <SolidColorBrush Color="Blue" x:Name="mSolidColorBrush"/>
      </Rectangle.Fill>
      <Rectangle.Triggers>
        <EventTrigger RoutedEvent="Rectangle.MouseEnter">
          <BeginStoryboard>
            <Storyboard>
              <DoubleAnimation Storyboard.TargetName="MyRectangle" Storyboard.TargetProperty="Width" From="100" To="200" Duration="0:0:1" />
              <ColorAnimation Storyboard.TargetName="mSolidColorBrush" Storyboard.TargetProperty="Color" From="Blue" To="Red" Duration="0:0:1" />  
            </Storyboard>
          </BeginStoryboard>
        </EventTrigger>
      </Rectangle.Triggers>
    </Rectangle> 
  </StackPanel>
</Page>
"@


$mywin = (presentation create "wpf test" wpftest 0 0 800 600)

presentation content $mywin (presentation page $page)

$pagewin = (presentation navigationwindow $page2)

$timer = timer 1000
$timer.add_Tick({console tick
presentation content $pagewin (presentation page $page)
dialog disable $timer})

$back = timer 1
dialog disable $back
$back.add_Tick({
window send $(winexists "Animate Height") $(key "BS")
dialog disable $back
})

$mywin.add_Closed({dialog enable $back})

dialog showmodal $mywin
dialog showmodal $pagewin

