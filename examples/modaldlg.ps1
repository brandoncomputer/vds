$Form = dialog create "Main Dialog" 0 0 309 226
    $SB = dialog add $Form StatusStrip 
    $List1 = dialog add $Form ListBox 10 10 272 114 "ListBox1"  
            $Add = dialog add $Form Button 130 52 64 24 "Add"  
            $Close = dialog add $Form Button 130 180 64 24 "Close"
            
            dialog set $SB.items[0] "Click Add to add an item of text to the list" 
            
$Add.add_Click({
child_dialog
})

$close.add_Click({
    close
})

function child_dialog(){

    $CForm = dialog create "Child Dialog" 0 0 309 108
    $CEDIT1 = dialog add $CForm TextBox 10 11 175 23 ""  
    $OK = dialog add $CForm Button 8 206 75 23 "OK"  
    $Cancel = dialog add $CForm Button 38 206 75 23 "Cancel"
    
    $OK.add_Click({
    $a = $(dlgtext $CEDIT1)
    list add $List1 $a
    cancel
    })
    
    $Cancel.add_Click({
    cancel 
    })
    
    dialog showmodal $CForm
}

function cancel(){
dialog close $CForm
}
function close(){
dialog close $Form
}
                
dialog show $Form