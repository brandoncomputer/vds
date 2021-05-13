$clockform = dialog create "Clock" 0 0 300 175
$datet = dialog add $clockform DateTimePicker 0 0 300
$label = dialog add $clockform label 20 0 300 175

$timer = timer 1000
$timer.add_Tick({
if ($(greater $(datetime).ToString("HH") 11)){$xx = "pm"} else {$xx = "am"}
dialog set $label ($(datetime).ToString("h:mm:ss")+" "+$xx)
})

dialog property $clockform backcolor "black"
dialog property $label forecolor "lime"

dialog property $label font "Comic Sans MS, 48" 

$clockform.add_Resize({
$resize = $(fdiv $(sum ($(winpos $(winexists "Clock") W)) ($(winpos $(winexists "Clock") H))) 12)
$resize = $(string $resize)
dialog property $label font "Comic Sans MS, $resize"
dialog setpos $label 20 0 $(winpos $(winexists "Clock") W) $(differ $(winpos $(winexists "Clock") H) 50)
dialog setpos $datet 0 0 $(differ $(winpos $(winexists "Clock") W) 20)
})
dialog show $clockform
$timer.Dispose()