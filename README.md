# Unity Build + Steam Deploy Scripts
Tools for removing some of the tedium of deploying to steam from your local machine.

The scripts allow you to build to multiple target platforms and deploy to steam with a couple of clips from the comfort of Unity.

**Note:** This package was made on Windows. It should be simple enough to migrate it to another OS if you need.

## Prerequisites
- You should be familiar with building in Unity and deploying your to Steam via SteamPipe. This ReadMe will not guide you through setting any of that up.
- You will need [GitBash](https://git-scm.com/downloads) installed or, you can update the ```BuildScript.cs``` script to open your bash terminal of choice.

# Set Up
1. Copy the contents of the Editor folder into your projects Editor folder *(if it doesn't exist in your project, then copy the whole folder).*
2. Open ```BuildScript.cs``` and update the required fields.
3. Open ```SteamDeploy.sh``` and update the required fields.
4. Take care with ```defaultDeploymentMessage```, it must match the ```"Desc"``` field inside of your app.vdf.

## Notes
If you haven't logged in to SteamCMD before, log in once before running these scripts. The scripts require that your password be cached.
