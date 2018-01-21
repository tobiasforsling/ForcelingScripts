using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.PostProcessing;

public class ForcelingControlPanel : MonoBehaviour{
    public GameObject[] NumberOfObjects;
    public static bool ObjActivity;
    public Camera MainCamera;

    public void Enable()
    {
        NumberOfObjects[1].SetActive(true);
    }

    public void Disable()
    {
        NumberOfObjects[1].SetActive(false);
    }

    public void EnablePostProcess()
    {
        //MainCamera.enabled = true;
    }

    public void DisablePostProcess()
    {
        //MainCamera.enabled = true;
    }
}
