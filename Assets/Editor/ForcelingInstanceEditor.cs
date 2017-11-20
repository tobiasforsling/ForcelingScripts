using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(ForcelingInstance))]
public class ForcelingInstanceEditor : Editor
{

    public override void OnInspectorGUI()
    {
        ForcelingInstance myscript = (ForcelingInstance)target;

        DrawDefaultInspector();

        GUILayout.Space(10);

        //Horizontal slot for spawn and delete buttons
        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        if (GUILayout.Button("Spawn Clones",  GUILayout.Height(40), GUILayout.Width(120)))
        {
            myscript.Killchildren();
            myscript.CalculateRandomRot();
            myscript.Buildobject();
        }
        GUILayout.FlexibleSpace();
        if (GUILayout.Button("Delete Clones", GUILayout.Height(40), GUILayout.Width(120)))
        {
            myscript.Killchildren();
        }
        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();

        GUILayout.Space(10);

        //Horizontal slot for refresh button
        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        if (GUILayout.Button("Refresh", GUILayout.Height(40), GUILayout.Width(120)))
        {
              myscript.Killchildren();
              myscript.Buildobject();
        }
        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();
        
        //Displaying messages whether clones have been created or not
        if (ForcelingInstance. Clonesexist == 1)
        {
            EditorGUILayout.HelpBox("Clones are spawned", MessageType.Info);
        }
        
        //Displaying message if clones doesnt exist
        if (ForcelingInstance. Clonesexist == 2)
        {
            EditorGUILayout.HelpBox("No clones created", MessageType.Warning);
        }

        //Displaying error if model is not assigend
        if (ForcelingInstance.Modelisassigned == 2)
        {
            EditorGUILayout.HelpBox("A model or prefab must be assigned", MessageType.Error);
        }
    }
}