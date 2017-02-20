# TitansimGosCalculator

This is a bash script to calculate GoS for a overload run using titansim callstat files.

Script needs 1 argument the titasnim call stat file to measure the GoS from. 
Inside the script at the top of the script add/remove the scenarios you want to measure GoS from:
Looks like this:
SCENARIOS="CallA_SIP_PSTN_SIP CallA_SIP_SIP CallA_SIP_PSTN2_SIP"
Here you se ther scenarios used.

Start script wiht:
./callculate_gos.sh current_cal._stat.txt


