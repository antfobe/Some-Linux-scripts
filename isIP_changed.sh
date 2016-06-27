#!/bin/bash

findersArray=(ipinfo.io/ip  ifconfig.me  icanhazip.com  ipecho.net/plain);
getIP() {
 IP="";
 local i=0;
## keeps trying until IP is not empty ("")
 while [[ -z "$IP" ]]; do
## waits response for 30 secs
  IP=`curl --max-time 30 ${findersArray[i]}`;
  ((i=(i+1) % ${#findersArray[@]}));
 done
## updates log with last valid source
 echo "**last update from ${findersArray[i]}**" >> logIP_change.txt;
## TODO update sources
}
## starts script with known IP
getIP
pubIP=$IP;
## infinite loop, keeps looking for changes in external ip
while true do
 getIP
##checks if public IP has changed
 if [ $IP -eq $pubIP ]
 then
  echo "everything OK :" `date` && echo "["`date`"]: $pubIP" >> logIP_change.txt;
 else
  echo "<IP CHANGED>  :" `date` && echo "["`date`"]: $pubIP" >> logIP_change.txt;
## updates change
 pubIP=$IP;
 fi;
## waits 60 min randomly
 sleep $(((RANDOM % 60) + 1));
done;
## notifies network users -> TODO
