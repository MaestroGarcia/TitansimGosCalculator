#!/bin/bash
set -o errexit     #to make your script exit when a command fails.
set -o nounset     #to exit when your script tries to use undeclared variables.

SCENARIOS="CallA_SIP_PSTN_SIP CallA_SIP_SIP CallA_SIP_PSTN2_SIP"

usage()
{
        echo ""
        echo "Script needs 1 arguments the call stat file to measure"
        echo "Inside the script at the top of the script add/remove the scenarios you want to measure GoS from."
        echo ""
}


input()
{
  regex='[0-9]{4}-[0-9]{2}-[0-9]{2}\s[0-9]{2}:[0-9]{2}'
  echo "Enter the start time in this way example: 2017-02-25 12:00"
  read starttime 
    while  [[ !($starttime =~ $regex) ]]; do
       echo "wrong format! should be ex: 2017-01-03 12:30"
      read starttime
    done
  
  echo "Enter the end time in this way example: 2017-02-25 12:00"
  read endtime
    while  [[ !($endtime =~ $regex) ]]; do
      echo "wrong format! should be ex: 2017-01-03 12:30"
    read endtime
    done

  clear
  printf "%-20s %-20s %-20s %-20s\n " "Scenario" "GoS %" "Starttime" "Stoptime"
}


calculate_GoS()
{
printf "%-80s\n" | tr " " -
for scenario in $SCENARIOS
  do
    startv=$(grep -e "$starttime" ${CALLSTATFILE} | grep -w -e ${scenario} | head -1 | awk '{printf "%d",$12}')
    startsuccess=$(grep -e "$starttime" ${CALLSTATFILE} | grep -w -e ${scenario} | head -1 | awk '{printf "%d",$14}')
    endv=$(grep -e "${endtime}" ${CALLSTATFILE} | grep -w -e ${scenario} | head -1 | awk '{printf "%d",$12}')
    endsuccess=$(grep -e "${endtime}" ${CALLSTATFILE} | grep -w -e ${scenario} | head -1 | awk '{printf "%d",$14}')
    resultGos=$(awk "BEGIN  {printf \"%.2f\" , ((${endsuccess}-${startsuccess})/(${endv}-${startv}))*100}")
    printf "%-20s %-20.2f %-20s %-20s\n" "${scenario}" "${resultGos}" "${starttime}" "${endtime}"
  done
  printf "\n"
}

###### MAIN PROGRAM ###########

if [[ $# == 0 || ${1} == --help ]]
    then 
     usage
     exit 1
    else
     CALLSTATFILE=$1   
     input
     calculate_GoS
fi
    

