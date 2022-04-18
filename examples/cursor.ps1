DPIAware
VisualStyle
$Form = dialog create "TEST CURSOR" 0 0 321 196
    $List1 = dialog add $Form ListBox 10 10 180 144 "ListBox1"  
            $reset = dialog add $Form Button 16 221 75 23 "reset"  
            $All = dialog add $Form Button 46 221 75 23 "All"  
         
list add $List1 AppStarting
list add $List1 Arrow
list add $List1 Cross
list add $List1 Default
list add $List1 Hand
list add $List1 Help
list add $List1 HSplit
list add $List1 IBeam
list add $List1 No
list add $List1 NoMove2D
list add $List1 NoMoveHoriz
list add $List1 NoMoveVert
list add $List1 PanNE
list add $List1 PanNorth
list add $List1 PanNW
list add $List1 PanSE
list add $List1 PanSouth
list add $List1 PanSW
list add $List1 PanWest
list add $List1 SizeAll
list add $List1 SizeNESW
list add $List1 SizeNS
list add $List1 SizeNWSE
list add $List1 SizeWE
list add $List1 UpArrow
list add $List1 VSplit
list add $List1 WaitCursor

$List1.add_Click({

dialog cursor $Form (item $List1)
})

$reset.add_Click({
dialog cursor $Form Default
})

$All.add_Click({
list seek $List1 0
$a = $(item $List1)
while ($a) {
dialog cursor $Form $a
wait .5
$a = $(next $List1)
}
})

            
            dialog show $Form
            
