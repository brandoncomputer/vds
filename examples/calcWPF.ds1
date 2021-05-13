 set-alias wpf presentation
 
 $win = wpf create "Admin Calculator" calc 0 0 148 229
 # calc becomes $calc, a wpf grid element inside of the $win window.
    $win.WindowStyle = 3
    $ComboBox1 = wpf add $calc combobox 5 5 120 20
    $TextBox1 = wpf add $calc textbox 5 5 100 20
    $TextBox1.TextAlignment = 'Right'  
        $ButtonCE = wpf add $calc Button 30 5 30 30 "CE"  
        $ButtonBSP = wpf add $calc Button 30 35 30 30 "<x"  
        $ButtonXSQ = wpf add $calc Button 30 65 30 30 "x sq"  
        $ButtonDiv = wpf add $calc Button 30 95 30 30 "/"  
        $Button7 = wpf add $calc Button 60 5 30 30 "7"  
        $Button8 = wpf add $calc Button 60 35 30 30 "8"  
        $Button9 = wpf add $calc Button 60 65 30 30 "9"  
        $ButtonMult = wpf add $calc Button 60 95 30 30 "*"  
        $Button4 = wpf add $calc Button 90 5 30 30 "4"  
        $Button5 = wpf add $calc Button 90 35 30 30 "5"  
        $Button6 = wpf add $calc Button 90 65 30 30 "6"  
        $ButtonMinus = wpf add $calc Button 90 95 30 30 "-"  
        $Button1 = wpf add $calc Button 120 5 30 30 "1"  
        $Button2 = wpf add $calc Button 120 35 30 30 "2"  
        $Button3 = wpf add $calc Button 120 65 30 30 "3"  
        $ButtonPlus = wpf add $calc Button 120 95 30 30 "+"  
        $ButtonRv = wpf add $calc Button 150 5 30 30 "+/-"  
        $Button0 = wpf add $calc Button 150 35 30 30 "0"  
        $ButtonDot = wpf add $calc Button 150 65 30 30 "."  
        $ButtonEq = wpf add $calc Button 150 95 30 30 "="  
        
        #This example is written mostly in PowerShell syntax. For a mostly DialogScript syntax comparison example, see calc.ds1
        
        $timer = timer 1000
        $timer.add_Tick({window ontop $(winexists "Admin Calculator")
        dialog disable $timer})

$ButtonEq.add_Click({
$match = $(match $ComboBox1 $textbox1.text)
if ($match -gt -1)
{# do nothing
}
else
{
    list add $ComboBox1 $textbox1.text
}
$textbox1.text = $(invoke-expression $textbox1.text);dialog focus $textbox1;window send $(winexists "Admin Calculator") $(ctrl $(key right);)
})

$ComboBox1.add_SelectionChanged({$textbox1.text = $combobox1.selecteditem})

$Button0.add_Click({$textbox1.text = $textbox1.text+'0';dialog focus $ButtonEq})
$Button1.add_Click({$textbox1.text = $textbox1.text+'1';dialog focus $ButtonEq})
$Button2.add_Click({$textbox1.text = $textbox1.text+'2';dialog focus $ButtonEq})
$Button3.add_Click({$textbox1.text = $textbox1.text+'3';dialog focus $ButtonEq})
$Button4.add_Click({$textbox1.text = $textbox1.text+'4';dialog focus $ButtonEq})
$Button5.add_Click({$textbox1.text = $textbox1.text+'5';dialog focus $ButtonEq})
$Button6.add_Click({$textbox1.text = $textbox1.text+'6';dialog focus $ButtonEq})
$Button7.add_Click({$textbox1.text = $textbox1.text+'7';dialog focus $ButtonEq})
$Button8.add_Click({$textbox1.text = $textbox1.text+'8';dialog focus $ButtonEq})
$Button9.add_Click({$textbox1.text = $textbox1.text+'9';dialog focus $ButtonEq})
$ButtonDot.add_Click({$textbox1.text = $textbox1.text+'.';dialog focus $ButtonEq})
$ButtonCE.add_Click({$textbox1.text = '';dialog focus $ButtonEq})
$ButtonBSP.add_Click({$textbox1.text = $(substr $textbox1.text 0 $(pred $(len $textbox1.text)));dialog focus $ButtonEq})
$ButtonXSQ.add_Click({$textbox1.text = $(invoke-expression $textbox1.text);$textbox1.text = $(invoke-expression ($textbox1.text+'*'+$textbox1.text));dialog focus $ButtonEq})
$ButtonDiv.add_Click({$textbox1.text = $textbox1.text+'/';dialog focus $ButtonEq})
$ButtonMult.add_Click({$textbox1.text = $textbox1.text+'*';dialog focus $ButtonEq})
$ButtonMinus.add_Click({$textbox1.text = $textbox1.text+'-';dialog focus $ButtonEq})
$ButtonPlus.add_Click({$textbox1.text = $textbox1.text+'+';dialog focus $ButtonEq})
$ButtonRv.add_Click({$textbox1.text = $(invoke-expression $textbox1.text);if ($(equal $(substr $textbox1.text 0 1) '-')){$textbox1.text = $(substr $textbox1.text 1 ($(len $textbox1.text)))}else{$textbox1.text = '-'+$textbox1.text};dialog focus $ButtonEq})
$ButtonPlus.add_Click({$textbox1.text = $textbox1.text+'.';dialog focus $ButtonEq})

        dialog showmodal $win
        #For fun, calculate 'notepad'
        #                   $(winexists notepad)
        #                   window send $(winexists notepad) "Hello World"

