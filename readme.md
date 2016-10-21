In some cases with UEFI machines (like the MS Surface line) you do not want to update the firmware if the battery is over 40%. if you do try the update will fail.

To get around this I developed this script to look at the level of all batteries every 60 seconds untill all of them are charged to at least 60%

Check the batterylevel, if it is below 60% display an HTA and loop until it is above 60%. in case of mutiple batteries loop untill all of them are above 60%

This is designed to be used in an OSD task sequence, but you can edit the script and HTA work in other soulitions.