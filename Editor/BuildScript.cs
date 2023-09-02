using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Editor
{
    public static class BuildScript
    {
        //Required
        private const string ScenesDirectory = "Assets/Scenes";
        
        //Required
        //the directory where your builds will be saved to
        //you can leave it prefilled or export your builds somewhere else
        private const string AutoBuildsDirectory = "Builds/AutoBuilds";
        
        //Required
        //the directory to the SteamDeploy.sh script
        //you can leave it prefilled or move your script to your preferred location
        private static readonly string DeployScriptPath = $"{Application.dataPath}/Editor/SteamDeploy/SteamDeploy.sh";
        
        //Optional
        //if not specified here will fall back to the Product Name in Project Settings => Player
        private static string _buildName = "";

        [MenuItem("Automation/Build")]
        public static void Build()
        {
            if (_buildName == "") _buildName = Application.productName;

            //add scenes in build settings to the build
            var totalScenes = SceneManager.sceneCountInBuildSettings;
            var sceneNames = new string[totalScenes];
            for (var i = 0; i < totalScenes; i++)
                sceneNames[i] = $"{ScenesDirectory}/{Path.GetFileName(SceneUtility.GetScenePathByBuildIndex(i))}";

            //the build Targets must be installed for whatever version of Unity you are using
            //install them via Unity Hub
            var builds = new List<BuildStuff>
            {
                new($"{AutoBuildsDirectory}/Windows/{_buildName}.exe", BuildTarget.StandaloneWindows),
                // new($"{BuildBasePath}/Linux/{_buildName}.x86_64", BuildTarget.StandaloneLinux64)
                // new($"{BuildBasePath}/OSX/{_buildName}.app", BuildTarget.StandaloneOSX)
            };

            foreach (var build in builds)
                BuildPipeline.BuildPlayer(sceneNames, build.Path, build.BuildTarget,
                    BuildOptions.None);
        }

        [MenuItem("Automation/Deploy")]
        private static void Deploy()
        {
            Process.Start(DeployScriptPath);
        }

        [MenuItem("Automation/Build + Deploy")]
        private static void BuildDeploy()
        {
            Build();
            Deploy();
        }
    }

    public class BuildStuff
    {
        public readonly BuildTarget BuildTarget;
        public readonly string Path;

        public BuildStuff(string path, BuildTarget buildTarget)
        {
            Path = path;
            BuildTarget = buildTarget;
        }
    }
}