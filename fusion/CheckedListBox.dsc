if @winexists(#CheckedListBox)
info only one instance may run
stop
end
 %%class = CheckedListBox
  DIALOG CREATE,New Dialog,-1,0,800,450,,resizable,class %%class
REM *** Modified by Dialog Designer on 2/23/2019 - 15:57 ***
  DIALOG ADD,BUTTON,BUTTON1,0,0,64,24,ListItems
  dialog add,list,list1,24,400,400,400

inifile open,@path(%0)CheckedListBox.ini
runh powershell -executionpolicy bypass -file @chr(34)@path(%0)CheckedListBox.ps1@chr(34) @strdel(@winexists(#%%class),1,1)
    window hide,@dlgtext()
   registry write,hcu,software\dialogshell,window,""
   registry write,hcu,software\dialgoshell,message,""
   registry write,hcu,software\dialogshell,check,""
   
repeat
wait .1
until @regread(hcu,software\dialogshell,window)

rem Putting dialog show after the reg write looks better, but causes a bug every few runs.
   DIALOG SHOW
registry write,hcu,software\dialogshell,window,ready




:timer
if @equal(@regread(hcu,software\dialogshell,check),load)
list loadfile,list1,checked.txt
registry write,hcu,software\dialogshell,check,""
end
%i = @regread(hcu,software\dialogshell,window)
if %i
window position,%i,0,0
%i = ""

%%count = 0
wait
LOADLIB user32.dll 
 if @ok() 
%%k = @strdel(@winexists(#%%class),1,1)
 %%knockout = @lib(user32,SetWindowLongA,INT:,%%k,-16,$10CF0000) 
 %%knockout = @lib(user32,SetWindowLongA,INT:,%%k,-20,INT: $2000000)
 FREELIB user32.dll
 end
    registry write,hcu,software\dialogshell,window,""
end

  :evloop
  wait event,.1
  goto @event()
  
  
  :close
  list clear,list1
  list savefile,list1,checked.txt
registry write,hcu,software\dialogshell,check,""
  exit

:button1button
 %%count = 0
info native fill list1
list clear,list1
repeat
%%count = @succ(%%count)
list add,list1,%%count
until @equal(%%count,100)

%%count = 0

info native fill checkedlistbox1
registry write,hcu,software\dialogshell,message,nativeload
while @not(@equal(@regread(hcu,software\dialogshell,message),""))
wait 0.1
wend

info fusion fill checkedlistbox1
registry write,hcu,software\dialogshell,message,clear
while @not(@equal(@regread(hcu,software\dialogshell,message),""))
wait 0.1
wend


repeat 

%%count = @succ(%%count)
registry write,hcu,software\dialogshell,message,%%count

while @not(@equal(@regread(hcu,software\dialogshell,message),""))
wait 0.1
wend

until @equal(%%count,100)
list clear,list1
goto evloop

:resize

 goto evloop
