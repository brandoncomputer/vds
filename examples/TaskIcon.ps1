$Form = dialog create "Taskicon" 0 0 254 223

<# 
#Start form hidden, uncomment
$htimer = timer 1
$htimer.add_Tick({
dialog hide $Form
$htimer.Enabled = $false
})#>

                                      #REPLACE WITH VALID ICON PATH
$taskicon = dialog add $form taskicon 'application.ico' 'HIDE-SHOW'
$pop = dialog popup $taskicon "Show,Hide"


function global:menuitemclick ($menu) {
    switch (dlgname $menu) {
        "Show" {
            dialog show $Form
        }
        "Hide" {
            dialog hide $Form
        }
    }
}

dialog show $Form