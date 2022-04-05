$form1 =   dialog create "Hello World" 500 500 300 300
$button1 = dialog add $form1 button 10 10 100 20 "Click Me"

$timer = timer 1000
$timer.add_Tick({
console "Tick"
})

$button1.add_Click({
$info = $(chr 34) + "Hello World!" + $(chr 34)
info $info #Comment: We could have just called called the string directly from the info command, but it's more fun to show a defined object (variable)
})

$button1.add_MouseHover({
console "you are hovering!"
})


dialog show $form1

#Code pauses execution when the form is shown.

#:CLOSE

console $(dlgprops $button1)

console "exit"
exit

#END SCRIPT