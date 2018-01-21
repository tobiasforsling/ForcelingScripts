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
        GUILayout.Space(10);

        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        if (GUILayout.Button("Enable", GUILayout.Height(40), GUILayout.Width(120)))
        {
            myscript.Enable();
        }

        if (GUILayout.Button("Disable", GUILayout.Height(40), GUILayout.Width(120)))
        {
            myscript.Disable();
        }

        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();

        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();

        if (GUILayout.Button("Enable Post Processing", GUILayout.Height(40), GUILayout.Width(200)))
        {
            myscript.EnablePostProcess();
        }


        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();

    }
}