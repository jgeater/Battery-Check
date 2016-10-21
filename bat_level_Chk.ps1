
#	============================================================================================'
#	File Name: bat_level_Chk.ps1
#
#	File Creator/Author: James Geater (jgeau)
#	
#	Functional Description: Check the batterylevel, if it is below 60% display an HTA and loop untill 
#   it is above 60%. in case of mutiple batteries loop untill all of them are above 60%
#
#	Revision History:
#  <Ver>	<Date>	    <Name>	      <Revision>
#   1.0    3/16/2016   jgeau        First release 
#   
#
#	============================================================================================'

#set initial varibles
$Min_levl = 95
$low_bat = 0
$Below_Min = 0
$BATT  = Get-WmiObject Win32_battery           #Get the battery infor for the system
$charge = $BATT.EstimatedChargeRemaining       #get the current charge level for each battery
$lowest_Bat_Lvl = $charge |measure -Minimum    #get the level of the battery with the lowest charge



# is this below the min bat level?? if so reset #Below_min
If ($lowest_Bat_Lvl.Minimum -lt $Min_levl) {$Below_Min = 1}
If ($lowest_Bat_Lvl.Minimum -ge $Min_levl) {$Below_Min = 0}


#loop while the battery is low
if ($Below_Min -eq 1){
do
{
    #put up HTA to tell user what is going on
    $HTA = Start-Process -FilePath TS-Charging.hta -PassThru
    
    #Refresh the battery data to get the most recent data
    $BATT  = Get-WmiObject Win32_battery
    $charge = $BATT.EstimatedChargeRemaining
    $lowest_Bat_Lvl = $charge |measure -Minimum #get the level of the battery with the lowest charge

    If ($lowest_Bat_Lvl.Minimum -lt $Min_levl) 
        {
        #Battery is still to low wait 60 seconds
        Sleep 60
        }

    If ($lowest_Bat_Lvl.Minimum -ge $Min_levl) #Battery charge is now good. we can exit cleanly
        {
        $Below_Min = 0 #Reset the varible and exit loop
        Get-Process mshta | Stop-Process  #Kill the HTA and exit
        break
        }
    }while ($Below_Min -eq 1)
}
