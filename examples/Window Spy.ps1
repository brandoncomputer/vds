
$Form = dialog create "Dialog Window Spy" 0 0 600 480
$Form.icon = (curdir)+"\..\res\magnifier.ico"
 $button =  dialog add $Form Button 400 15 100 30 "Capture"
 $alabel =  dialog add $Form label 400 200 500 500 "Click Capture, then hover over window."
# Does often crash..."
 $Label1 = dialog add $Form Textbox 15 15 550 380
    dialog property $Label1 multiline $true
    dialog property $Label1 Font "Segoe UI Black,8"
    
    
$button.add_Click({
    
    $button.text = "5"
    
    $i = 0
    
    while ($i -lt 5)
    {
           start-sleep 1
        $i = $i+1
        $button.text = ((5-$i) | out-string).trim()
    }
    
    $button.text = "Capture"
    
    
                $win = $(winatpoint $(mousepos x) $(mousepos y))

                
                
                if ($win -ne 0)
                {

                        $buildstring = "
Window: $win
Window Class: $(winclass $win)
Window Text: $(wintext $win)
"
 dialog set $Label1 $buildstring
$ask = $(ask "Attempt to Capture parents?")

if ($ask -eq "Yes")
{

$tabstr = ""

$parent = $(winparent $win)

if ($parent -ne $null){

while ($parent -ne 0)
{
 #   start-sleep -s 1
    $tabstr+=$(tab)
$buildstring+= "
$tabstr Parent: $parent
$tabstr Parent Class: $(winclass $parent)
$tabstr Parent Text: $(wintext $parent)
"
 dialog set $Label1 $buildstring
 $parent = $(winparent $parent)
}
dialog set $Label1 $buildstring
$buildstring = ""

}
}

}
})

        
    
    dialog show $Form
            
            