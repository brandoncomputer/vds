#This may be our only type of GUI available in PowerShell Core. This should be OK, PowerShell Core is cross platform
#This is good news, DialogShell (vds.psm1) will exists at minimum as a module in PowerShell Core, and I think this
#could actually be served to multiple clients using various browsers... not my intent here.
#Update: This does work in client server relationships. Oops, that wasn't the goal.

import-module c:\vds\trunk\vds.psm1
#randomize port
$random = random 2000 10000

#start server
$vdsServer = server start "http://localhost" $random

#recall server name
$server = 'http://localhost:' + $random + '/'

#launch gui window
#run "start $server"
run "mshta $server"

    #do it until the program ends.
    while(1){
    
        #wait event
        $event = (server watch $vdsServer)
        
        #event - "/" is basically evloop. It's asking for the GUI content.
        if(equal (server context $event) "/") {
        
            #prepare return for client
            $return = @"
            <title>Get Power Profile - $server</title>
            <body onbeforeunload="exitFunction()">
            <!--txt1 is the commands the user wants to run.-->
            <textarea rows="8" style="width:800px; vertical-align: top; height=150px;" name=txt1 id=txt1>
&#036;currentpowerpolicy = (regread 'hkcu:Control Panel\PowerCfg' CurrentPowerPolicy);
(regread "hkcu:Control Panel\PowerCfg\powerpolicies\&#036;currentpowerpolicy" 'Name')
            </textarea><br>
            <!--The button sends the run request to frameUs-->
            <button onclick="myFunction()" style="vertical-align: top">Execute</button>

            <script>
                // Application quit by user handlers
			function exitFunction () {
			frameUs.location.href = '$server' + 'server stop &#036;vdsServer;exit 12;'
			}	
				
                function myFunction() {
                //  frameUs location becomes the client request and is read by the server wait event. 
                //  frameUs will send the contents of txt1 to the server and will contain the result from the server when the request is complete.
                    frameUs.location.href = '$server' + txt1.value;
                    // It takes time for the server to fill the request result, so we can't update immediately.
                    timerx = setTimeout(myTimer, 250)
                }
                function myTimer() {
                    // Update the server return result from frameUs back into txt1
                    var x = document.getElementById('frameUs');
                    var doc = x.contentDocument? x.contentDocument: x.contentWindow.document;
                    txt1.value = doc.body.innerHTML;
                    // Stop ticking.
                    window.clearTimeout(timerx)
                }
            </script>
            <iframe name=frameUs id=frameUs style='visibility:hidden'></iframe>
"@
        }
        else {
            #Get the event request.
            $result = (server context $event)
            #run the request locally.
            $run = (run $(substr $result 1 $(len $result)))
            #prepare the return
            $return = "<body>$run</body>"
        }
        #return the result back to the client.
        server return $event $return
    }
    #stop the server
server stop $vdsServer
