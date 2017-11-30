using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(InstanceScript))]
public class InstanceEditor : Editor
{



    public override void OnInspectorGUI()
    {
        InstanceScript myscript = (InstanceScript)target;

        DrawDefaultInspector();

        GUILayout.Space(10);

        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        //Horizontal slot for spawn and delete buttons
        if (GUILayout.Button("Spawn Clones", GUILayout.Height(40), GUILayout.Width(120)))
        {
            myscript.Killchildren();
            myscript.BuildMultiple();
        }
        GUILayout.FlexibleSpace();
        if (GUILayout.Button("Delete Clones", GUILayout.Height(40), GUILayout.Width(120)))
        {
            myscript.Killchildren();
        }
        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();

        //DISPLAY ERROR IF AMOUNT IS 0
        if (myscript.NumberOfObjects.Length == 0)
        {
            EditorGUILayout.HelpBox("Amount of objects shouldn't be 0", MessageType.Error);
        }

        //DISAPLY ERROR IF OBJECT FIELDS ARE EMPTY
        if (InstanceScript.Modelisassigned == 2)
        {
            EditorGUILayout.HelpBox("All objects must be assigned", MessageType.Error);
        }


        GUILayout.Space(10);

        //Horizontal slot for refresh button
        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        if (GUILayout.Button("Refresh", GUILayout.Height(40), GUILayout.Width(120)))
        {
              myscript.Killchildren();
              myscript.BuildMultiple();
        }
        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();
        
        //DISPLAYING MESSAGES AT BOTTOM OF INSPECTOR

        //Displaying messages whether clones have been created or not
        if (InstanceScript. Clonesexist == 1)
        {
            EditorGUILayout.HelpBox("Clones are spawned", MessageType.Info);
        }
        
        //Displaying message if clones doesnt exist
        if (InstanceScript. Clonesexist == 2)
        {
            EditorGUILayout.HelpBox("No clones created", MessageType.Warning);
        }

    }
}