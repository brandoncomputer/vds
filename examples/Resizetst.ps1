$Form = dialog create "Resizable Window" 0 0 254 223
    $File = dialog add $Form MenuStrip "&File" "E&xit"
            $SB = dialog add $Form StatusStrip  
            $ED = dialog add $Form TextBox 25 0 238 150 "" 
            dialog property $ED Multiline "$True" 
            dialog property $ED WordWrap "$True" 
            
            dialog set $SB.items[0] "Status"
            
function global:menuitemclick ($menu) {
    switch (dlgname $menu) {
    "E&xit" {
    dialog close $Form
        }
    }
}

$Form.add_Resize({
resize
})

function resize(){
    $w = $(dlgpos $Form w)
    $h = $(dlgpos $Form h)
    $dh = $(sum 60 $(dlgpos $SB H))
    dialog setpos $ED 25 0 $(differ $w 15) $(differ $h $dh)
}
            resize


dialog show $Form