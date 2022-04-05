    $calc = dialog create "Admin Calculator" 0 0 148 229
    $calc.FormBorderStyle = 6
    
    $calc.maximumsize = new-object System.Drawing.Size((148 * $(screeninfo scale)),(229 * $(screeninfo scale)))
    $calc.minimumsize = new-object System.Drawing.Size((148 * $(screeninfo scale)),(229 * $(screeninfo scale)))
    $TextBox1 = dialog add $calc textbox 5 5 100 20 "" 
    $ComboBox1 = dialog add $calc combobox 5 5 120 20 "" 
    $TextBox1.TextAlign = 'Right'
                dialog property $TextBox1 Multiline "" 
                dialog property $TextBox1 Maxlength "0" 
                dialog property $TextBox1 Wordwrap "true" 
                dialog property $TextBox1 Scrollbars "none" 
                dialog property $TextBox1 acceptstab "" 
                dialog property $TextBox1 acceptsreturn ""  
        $ButtonCE = dialog add $calc Button 30 5 30 30 "CE"  
        $ButtonBSP = dialog add $calc Button 30 35 30 30 "<x"  
        $ButtonXSQ = dialog add $calc Button 30 65 30 30 "x sq"  
        $ButtonDiv = dialog add $calc Button 30 95 30 30 "/"  
        $Button7 = dialog add $calc Button 60 5 30 30 "7"  
        $Button8 = dialog add $calc Button 60 35 30 30 "8"  
        $Button9 = dialog add $calc Button 60 65 30 30 "9"  
        $ButtonMult = dialog add $calc Button 60 95 30 30 "*"  
        $Button4 = dialog add $calc Button 90 5 30 30 "4"  
        $Button5 = dialog add $calc Button 90 35 30 30 "5"  
        $Button6 = dialog add $calc Button 90 65 30 30 "6"  
        $ButtonMinus = dialog add $calc Button 90 95 30 30 "-"  
        $Button1 = dialog add $calc Button 120 5 30 30 "1"  
        $Button2 = dialog add $calc Button 120 35 30 30 "2"  
        $Button3 = dialog add $calc Button 120 65 30 30 "3"  
        $ButtonPlus = dialog add $calc Button 120 95 30 30 "+"  
        $ButtonRv = dialog add $calc Button 150 5 30 30 "+/-"  
        $Button0 = dialog add $calc Button 150 35 30 30 "0"  
        $ButtonDot = dialog add $calc Button 150 65 30 30 "."  
        $ButtonEq = dialog add $calc Button 150 95 30 30 "="  
        
        $timer = timer 1000
        $timer.add_Tick({window ontop $(winexists $calc)
        dialog disable $timer})

$calc.AcceptButton = $ButtonEq

$ButtonEq.add_Click({
    $match = (match $ComboBox1 (dlgtext $textbox1))
if (greater $match -1)
{# do nothing
}
else
{
    list add $ComboBox1 (dlgtext $textbox1)
}
dialog set $textbox1 (run (dlgtext $textbox1))
dialog focus $textbox1;window send (winexists $textbox1) $(ctrl $(key right))
})

$ComboBox1.add_SelectedIndexChanged({dialog set $textbox1 (dlgtext $combobox1)})

$Button0.add_Click({
    dialog set $textbox1 ((dlgtext $textbox1)+'0')
})
$Button1.add_Click({dialog set $textbox1 ((dlgtext $textbox1)+'1')})
$Button2.add_Click({dialog set $textbox1 ((dlgtext $textbox1)+'2')})
$Button3.add_Click({dialog set $textbox1 ((dlgtext $textbox1)+'3')})
$Button4.add_Click({dialog set $textbox1 ((dlgtext $textbox1)+'4')})
$Button5.add_Click({dialog set $textbox1 ((dlgtext $textbox1)+'5')})
$Button6.add_Click({dialog set $textbox1 ((dlgtext $textbox1)+'6')})
$Button7.add_Click({dialog set $textbox1 ((dlgtext $textbox1)+'7')})
$Button8.add_Click({dialog set $textbox1 ((dlgtext $textbox1)+'8')})
$Button9.add_Click({dialog set $textbox1 ((dlgtext $textbox1)+'9')})
$ButtonCE.add_Click({dialog set $textbox1 ''})
$ButtonBSP.add_Click({
    dialog set $textbox1 (substr (dlgtext $textbox1) 0 (pred (len (dlgtext $textbox1))))
})
$ButtonXSQ.add_Click({
    dialog set $textbox1 $(invoke-expression (dlgtext $textbox1))
    dialog set $textbox1 $(invoke-expression (((dlgtext $textbox1)+'*')+(dlgtext $textbox1)))
})
$ButtonDiv.add_Click({dialog set $textbox1 ((dlgtext $textbox1)+'/')})
$ButtonMult.add_Click({dialog set $textbox1 ((dlgtext $textbox1)+'*')})
$ButtonMinus.add_Click({dialog set $textbox1 ((dlgtext $textbox1)+'-')})
$ButtonPlus.add_Click({dialog set $textbox1 ((dlgtext $textbox1)+'+')})
$ButtonRv.add_Click({
    dialog set $textbox1 $(invoke-expression (dlgtext $textbox1))
    if ($(equal $(substr (dlgtext $textbox1) 0 1) '-')){
        #take away minus symbol
        dialog set $textbox1 $(substr $(dlgtext $textbox1) 1 ($(len $(dlgtext $textbox1))))
    }
    else{
    #prepend the minus symbol
    dialog set $textbox1 "-$(dlgtext $textbox1)"
    }
})
$ButtonPlus.add_Click({dialog set $textbox1 ((dlgtext $textbox1)+'.')})

        dialog show $calc
        #For fun, calculate 'notepad'
        #                   $(winexists notepad)
        #                   window send $(winexists notepad) "Hello World"

