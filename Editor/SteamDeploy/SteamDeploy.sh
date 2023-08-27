#!/bin/bash
# ============================================================================= #
#                                                                               #
#                                Unity => Steam                                 #                
#                            Build + Deploy Script                              #
#                                                                               #
# Author: Pet Pumpkin                                                           #
# Website: https://petpumpkin.dev                                               #
# Repository: https://github.com/PetPumpkin/unity-steampipe-deployment-script   #
#                                                                               #
# ============================================================================= #

# Required
deploymentVDFPath=""
defaultDeploymentMessage="auto-build-deploy" #make sure this matches the "Desc" field in your app.vdf
steamcmdPath="" #path to steamcmd.exe
steamUser=""

# Optional - call a serverless function (or, whatever)
# for example, I have a cloud function which calls a discord webhook which posts a message in my teams discord server
successNotificationURL=""


function setDeploymentDescription(){
	echo Enter Deployment Message:
	read -r deploymentMessage
}

function deployToSteam(){
  printf "\nStarting Deployment\n\n"
  printf "\nIf you exit this early, you may mangle the 'Desc' field in your app.vdf and have to update it by hand.\n\n\n"
  sleep 1
  
  echo Updating Deployment Description Message
  sed -i -e "s/$defaultDeploymentMessage/$deploymentMessage/g" "$deploymentVDFPath"
  echo Done

  echo Deploying To Steam
  #Note: the path to VDF is relative to SteamCMD's location (if you're not using an absolute path you may have errors)
  "$steamcmdPath" +login $steamUser +run_app_build "$deploymentVDFPath" +quit
  echo Done

  echo Resetting Deployment Description Message
  sed -i -e "s/$deploymentMessage/$defaultDeploymentMessage/g" "$deploymentVDFPath"
  echo Done
}

function sendSuccessNotification(){
	if [[ $successNotificationURL == "" ]];
	then
		echo No Success Notification URL provided	
	else
		echo Sending Message To Discord
		curl -G $successNotificationURL --data-urlencode "msg=$deploymentMessage"
	fi
}

function pressed() {
    if [[ $1 =~ ^[$2]$ ]]; then
        return 0
    else
        return 1
    fi
}

# Program Starts Here
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" || exit ; pwd -P )
cd "$parent_path" || exit

keepRunning=true
while $keepRunning
do
	echo
	echo ~~~~~~~~~~~~~~~~~~~~~~~~~
	echo Build \& Deploy to Steam!
	echo ~~~~~~~~~~~~~~~~~~~~~~~~~
	echo 
	echo Press D to Deploy
	echo Press S to silently Deploy \(no success notification\)
	echo Press anything else to quit.
	read -r -n1 runParams
	echo 
	
	if pressed "$runParams" "Dd"; then
		echo Deploy
		setDeploymentDescription
		deployToSteam
		sendSuccessNotification
	elif pressed "$runParams" "Ss"; then
		echo Silent Deploy
		setDeploymentDescription
		deployToSteam
	else
		echo Quitting, bye bye!
		sleep 1
		keepRunning=false
	fi
done




