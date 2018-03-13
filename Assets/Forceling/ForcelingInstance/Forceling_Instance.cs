using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Forceling_Instance : MonoBehaviour {
    public Vector3 Offset;
    public bool UseRandomRotation = false;
    public Vector3 RandomRotation;
    [HideInInspector]
    public Vector3 NewPos;
    [HideInInspector]
    public static int Clonesexist = 3; //1=yes 2=no 3=unknown
    [HideInInspector]
    public static int Modelisassigned = 3; //1=yes 2=no 3=unknown
    public int NumberOfClones;

    //Multiple Objects
    [HideInInspector]
    public static bool UseMultipleObj;
    public GameObject[] NumberOfObjects;
    public static int nextobject;
    public static int currentobject;

    //Rotation
    [HideInInspector]
    public Vector3 RotationTemp;
    [HideInInspector]
    public Vector3 RotationNew;

    public void BuildMultiple()
    {
        //Checking if all object fields are assigned
        for (int i = 0; i < NumberOfObjects.Length; i++)
        {
            if (NumberOfObjects[i] == null)
            {
                Modelisassigned = 2;
                //Debug.Log("Not all models assigned");
                break;
            }
            else
            {
                Modelisassigned = 1;
            }
        }

        //If no empty field was found start the process of spawning clones
        if(Modelisassigned == 1)
        {
            NewPos = this.gameObject.transform.position;
            //IF MORE THAN ONE OBJECT IS ASSIGNED SPAWN WITH RANDOM ID
            if (NumberOfObjects.Length > 1)
            {
                if (UseRandomRotation == true)
                {
                    for (int i = 0; i < NumberOfClones; i++)
                    {
                        NewPos += Offset;

                        while (currentobject == nextobject)
                        {
                            nextobject = (Random.Range((0), NumberOfObjects.Length));
                        }

                        //Calculation Random rotation
                        RotationNew = new Vector3(Random.Range(0, RandomRotation.x), Random.Range(0, RandomRotation.y), Random.Range(0, RandomRotation.z));

                        //Create clone as child at newpos
                        var newClone = Instantiate(NumberOfObjects[nextobject], NewPos, Quaternion.Euler(RotationNew));
                        newClone.transform.parent = gameObject.transform;

                        currentobject = nextobject;
                        Modelisassigned = 1;
                        Clonesexist = 1;
                    }
                    NewPos = this.gameObject.transform.position;
                }
                else
                {
                    for (int i = 0; i < NumberOfClones; i++)
                    {
                        NewPos += Offset;

                        while (currentobject == nextobject)
                        {
                            nextobject = (Random.Range((0), NumberOfObjects.Length));
                        }

                        //Create clone as child at newpos
                        var newClone = Instantiate(NumberOfObjects[nextobject], NewPos, Quaternion.identity);
                        newClone.transform.parent = gameObject.transform;

                        currentobject = nextobject;
                        Modelisassigned = 1;
                        Clonesexist = 1;
                    }
                    NewPos = this.gameObject.transform.position;
                }
            }

            //IF LESS THAN ONE IS ASSIGNED SPAWN WITH FIXED ID
            else
            {
                if (UseRandomRotation == true)
                {
                    for (int i = 0; i < NumberOfClones; i++)
                    {
                        NewPos += Offset;

                        //Calculation Random rotation
                        RotationNew = new Vector3(Random.Range(0, RandomRotation.x), Random.Range(0, RandomRotation.y), Random.Range(0, RandomRotation.z));

                        //Create clone as child at newpos
                        var newClone = Instantiate(NumberOfObjects[0], NewPos, Quaternion.Euler(RotationNew));
                        newClone.transform.parent = gameObject.transform;

                        Modelisassigned = 1;
                        Clonesexist = 1;
                    }
                    NewPos = this.gameObject.transform.position;
                }
                else
                {
                    for (int i = 0; i < NumberOfClones; i++)
                    {
                        NewPos += Offset;

                        //Create clone as child at newpos
                        var newClone = Instantiate(NumberOfObjects[0], NewPos, Quaternion.identity);
                        newClone.transform.parent = gameObject.transform;

                        Modelisassigned = 1;
                        Clonesexist = 1;
                    }
                    NewPos = this.gameObject.transform.position;
                }
            }
        }
    }

    public void Killchildren()
    {
        //Deleting children
        var children = new List<GameObject>();
        foreach (Transform child in transform) children.Add(child.gameObject);
        children.ForEach(child => DestroyImmediate(child));

        //Setting clones existance to false
        Clonesexist = 2;
    }

}
