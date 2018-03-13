using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(Forceling_Instance))]
public class InstanceEditor : Editor
{



    public override void OnInspectorGUI()
    {
        Forceling_Instance ForcelingInstance = (Forceling_Instance)target;

        DrawDefaultInspector();

        GUILayout.Space(10);

        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        //Horizontal slot for spawn and delete buttons
        if (GUILayout.Button("Spawn Clones", GUILayout.Height(40), GUILayout.Width(120)))
        {
            ForcelingInstance.Killchildren();
            ForcelingInstance.BuildMultiple();
        }
        GUILayout.FlexibleSpace();
        if (GUILayout.Button("Delete Clones", GUILayout.Height(40), GUILayout.Width(120)))
        {
            ForcelingInstance.Killchildren();
        }
        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();

        //DISPLAY ERROR IF AMOUNT IS 0
        if (ForcelingInstance.NumberOfObjects.Length == 0)
        {
            EditorGUILayout.HelpBox("Amount of objects shouldn't be 0", MessageType.Error);
        }

        //DISAPLY ERROR IF OBJECT FIELDS ARE EMPTY
        if (Forceling_Instance.Modelisassigned == 2)
        {
            EditorGUILayout.HelpBox("All objects must be assigned", MessageType.Error);
        }


        GUILayout.Space(10);

        //Horizontal slot for refresh button
        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        if (GUILayout.Button("Refresh", GUILayout.Height(40), GUILayout.Width(120)))
        {
            ForcelingInstance.Killchildren();
            ForcelingInstance.BuildMultiple();
        }
        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();
        
        //DISPLAYING MESSAGES AT BOTTOM OF INSPECTOR

        //Displaying messages whether clones have been created or not
        if (Forceling_Instance. Clonesexist == 1)
        {
            EditorGUILayout.HelpBox("Clones are spawned", MessageType.Info);
        }
        
        //Displaying message if clones doesnt exist
        if (Forceling_Instance. Clonesexist == 2)
        {
            EditorGUILayout.HelpBox("No clones created", MessageType.Warning);
        }
    }
}