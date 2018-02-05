using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.PostProcessing;

public class ForcelingControlPanel : MonoBehaviour{
    public Camera MainCamera;
    public Light DirectionalLight;
    public GameObject Cubes;
    [HideInInspector]
    public static int Objectmissing = 0; //Unknown=0 true=1 false=2

    public void EnablePostProcess()
    {
        if (MainCamera == null)
        {
            Objectmissing = 1;
        }
        else
        {
            Objectmissing = 2;
            MainCamera.GetComponent<PostProcessingBehaviour>().enabled = true;
        }

    }

    public void DisablePostProcess()
    {
        if (MainCamera == null)
        {
            Objectmissing = 1;
        }
        else
        {
            Objectmissing = 2;
            MainCamera.GetComponent<PostProcessingBehaviour>().enabled = false;
        }
    }

    public void EnableDirLight()
    {
        if (DirectionalLight == null)
        {
            Objectmissing = 1;
        }
        else
        {
            Objectmissing = 2;
            DirectionalLight.GetComponent<Light>().enabled = true;
        }
    }

    public void DisableDirLight()
    {
        if (DirectionalLight == null)
        {
            Objectmissing = 1;
        }
        else
        {
            Objectmissing = 2;
            DirectionalLight.GetComponent<Light>().enabled = false;
        }
    }

    public void EnableCubes()
    {
        if (Cubes == null)
        {
            Objectmissing = 1;
        }
        else
        {
            Cubes.SetActive(true);
            Objectmissing = 2;
        }
    }

    public void DisableCubes()
    {
        if (Cubes == null)
        {
            Objectmissing = 1;
        }
        else
        {
            Objectmissing = 2;
            Cubes.SetActive(false);
        }
    }
}
