$Form = dialog create "Drag and Drop Example" 0 0 309 226
    $SB = dialog add $Form StatusStrip  
            $LB = dialog add $Form ListBox 10 10 272 114 "ListBox1"  
            $OK = dialog add $Form Button 130 52 64 24 "OK"  
            $Cancel = dialog add $Form Button 130 180 64 24 "Cancel"
            $LB.AllowDrop = $True

          
$LB.add_DragEnter({
    list clear $LB
    list dropfiles $LB $_
    dialog set $SB.items[0] "$(count $LB) files dropped"
})


$OK.add_Click({
    cancel
})

$Cancel.add_Click({
    cancel
})

function cancel(){
dialog close $Form
}

dialog show $Form
                          




