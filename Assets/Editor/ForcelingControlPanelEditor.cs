using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(ForcelingControlPanel))]
public class ForcelingControlPanelEditor : Editor
{
    public override void OnInspectorGUI()
    {
        ForcelingControlPanel myscript = (ForcelingControlPanel)target;

        DrawDefaultInspector();

        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();

        if (GUILayout.Button("Enable Post Processing", GUILayout.Height(40), GUILayout.Width(200)))
        {
            myscript.EnablePostProcess();
        }

        if (GUILayout.Button("Disable Post Processing", GUILayout.Height(40), GUILayout.Width(200)))
        {
            myscript.DisablePostProcess();
        }

        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();

        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();

        if (GUILayout.Button("Enable Directional Light", GUILayout.Height(40), GUILayout.Width(200)))
        {
            myscript.EnableDirLight();
        }

        if (GUILayout.Button("Disable Directional Light", GUILayout.Height(40), GUILayout.Width(200)))
        {
            myscript.DisableDirLight();
        }

        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();

        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();

        if (GUILayout.Button("Enable Cubes", GUILayout.Height(40), GUILayout.Width(200)))
        {
            myscript.EnableCubes();
        }

        if (GUILayout.Button("Disable Cubes", GUILayout.Height(40), GUILayout.Width(200)))
        {
            myscript.DisableCubes();
        }

        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();

        //Displaying message if manipulated object is not assigned
        if (ForcelingControlPanel.Objectmissing == 1)
        {
            EditorGUILayout.HelpBox("The object you are trying to control is not assigned", MessageType.Error);
        }
    }
}