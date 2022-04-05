#Correct variables per language
$title = "Visual DialogShell SendKey demonstration"
$a = "Wordpad"
$w = "Document - Wordpad"
$z = "Save As"

$p1 = $(input "Enter your name" $title "User")
$p2 = $(input "Enter your birthday" $title "dd/mm/yyyy")
warn "Be sure to set your keyboard lowercase $(cr)$(cr)Hit enter to start ..."

if ($(winexists $w)){
    window activate $(winexists $w)
}
else {
start-process -filepath "$(chr 34)$(env programfiles)\Windows NT\Accessories\$a.exe$(chr 34)"
}

$c = 3000
 
 while (-not $(winexists $w)) {
    $c = $(pred $c)
    if ($(zero $c))
    {
        warn "Can't launch $($a).exe!"
        exit -1
        }
}

$w = $(winexists $w)

window settext $w $title

wait 1

window position $w 5 480 800 1200
# enter some text

function checkok(){
    if ($(not $(ok))){
    window send $w "** The result of ok was false after the    $(cr)"
    window send $w "** previous line was sent, indicating that $(cr)"
    window send $w "** one or more of the characters was not $(cr)"
    window send $w "** a valid keyboard character $(cr)"
    }
}

window send $w "Hello $p1 ! $(cr)This is a test string$(cr)"
checkok
window send $w "The current directory is $(curdir)$(cr)"
checkok
window send $w "$(tab)This text is indented.$(cr)"
checkok
window send $w "$(shift 'and this text is in capitals')$(cr)"
checkok
window send $w "5 > 4 = true?$(cr)"
checkok

function days(){

$p3 = [DateTime]::ParseExact($p2,"dd/MM/yyyy",$null)
$today = (get-date)

$diff = $today - $p3

return $diff
}

if (-not $(equal $pw 'dd/mm/yyyy')){
    window send $w "You'd already spent $(days) days on earth !"
checkok
} 

window send $w "The date is: $(get-date)$(cr)$(cr)"
wait 1
checkok
window send $w "Let's copy some text to the clipboard...$(cr)"
wait 1
checkok
window send $w "$(ctrl $(key 'home'))$(shift $(key 'end')$(key 'down')$(key 'down')$(key 'end'))"
wait 1
window send $w "$(ctrl c)"
wait 1
window send $w "$(ctrl $(key 'end'))"
wait 1
window send $w "... and insert the copied text here.$(cr)"
wait 1
checkok
window send $w "$(shift $(key 'insert'))"
window send $w "$(cr)$(cr)"
wait 3
window send $w "Here are some accented characters:$(cr)"
checkok
window send $w "???????????$(chr 255)$(cr)"
checkok
window send $w "$(cr)"
wait 2
window send $w "$(cr) Now let's save the file.$(cr)"
checkok
window send $w "$(alt f)a"
wait 1
$c = 1000
 
 while (-not $(winexists $z)) {
    $c = $(pred $c)
    if ($(zero $c))
    {
    warn "Cannot find window $($z) - aborting$(cr)Check the hotkey value at line 99,$(cr)according to your Wordpad version !"
        exit -1
        }
}

$z = $(winexists $z)

wait 1
window send $z "Test"
wait 2
window send $z "$(esc)$(esc)"
wait 1
window send $w "Changed my mind!$(cr)"

window send $w "$(alt $(key 'f4'))"

$c = 1000
 
 while (-not $(winexists $title)) {
    $c = $(pred $c)
    if ($(zero $c))
    {
    warn "Cannot find window $(chr 32)$title$(chr 32) - aborting"
        exit -1
        }
}

window send $a "$(alt 'n')"
info "End of demonstration" $title
exit 0
