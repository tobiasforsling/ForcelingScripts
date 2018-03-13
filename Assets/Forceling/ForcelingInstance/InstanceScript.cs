using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InstanceScript : MonoBehaviour {
    public Vector3 Offset;
    public Vector3 Rotation;
    [HideInInspector]
    public Vector3 RotationTemp;
    [HideInInspector]
    public Vector3 NewPos;
    [HideInInspector]
    public static int Clonesexist = 3; //1=yes 2=no 3=unknown
    [HideInInspector]
    public static int Modelisassigned = 3; //1=yes 2=no 3=unknown
    public int NumberofClones;
    //Multiple Objects
    [HideInInspector]
    public static bool UseMultipleObj;
    public GameObject[] NumberOfObjects;
    public static int nextobject;
    public static int currentobject;

    public void GenerateRandom()
    {

    }

    public void BuildMultiple()
    {

        //Checking if all object fields are assigned
        for (int i = 0; i < NumberOfObjects.Length; i++)
        {
            if (NumberOfObjects[i] == null)
            {
                Modelisassigned = 2;
                Debug.Log("Not all models assigned");
                break;
            }
            else
            {
                Modelisassigned = 1;
            }
        }

        //If no empty field is found start spawning clones
        if(Modelisassigned == 1)
        {
            //IF MORE THAN ONE OBJECT IS ASSIGNED SPAWN WITH RANDOM ID
            if (NumberOfObjects.Length > 1)
            {
                for (int i = 0; i < NumberofClones; i++)
                {
                    NewPos += Offset;

                    while (currentobject == nextobject)
                    {
                        nextobject = (Random.Range((0), NumberOfObjects.Length));
                    }
                    //Debug.Log("Clone " + nextobject + " spawned at" + NewPos);


                    //Create clone as child at newpos
                    var newClone = Instantiate(NumberOfObjects[nextobject], NewPos, Quaternion.Euler(RotationTemp));
                    newClone.transform.parent = gameObject.transform;

                    currentobject = nextobject;
                    Modelisassigned = 1;
                    Clonesexist = 1;
                }
                NewPos = Vector3.zero;
            }
            //IF LESS THAN ONE IS ASSIGNED SPAWN WITH FICED ID
            else
            {
                for (int i = 0; i < NumberofClones; i++)
                {
                    NewPos += Offset;

                    //Debug.Log("Clone " + nextobject + " spawned at" + NewPos);

                    //Create clone as child at newpos
                    var newClone = Instantiate(NumberOfObjects[0], NewPos, Quaternion.Euler(RotationTemp));
                    newClone.transform.parent = gameObject.transform;

                    Modelisassigned = 1;
                    Clonesexist = 1;
                }
            }
            NewPos = Vector3.zero;
        }
    }


    public void CalculateRandomRot()
    {
        //Use a random factor that user gives that affects the actual rotation values
        RotationTemp = new Vector3(Random.Range(-Rotation.x, Rotation.x), Random.Range(-Rotation.y, Rotation.y), Random.Range(-Rotation.z, Rotation.z));
    }
    /*
    public void Buildobject()
    {
        for(int i = 0; i < NumberofClones; i++)
        {
            //Checking if a model has been assigned, if yes loop is broken
            if (Model1 == null)
            {
                Modelisassigned = 2;
                break;
            }
            else
            {
                
                //Applying offset to Newpos
                NewPos += Offset;

                //Create clone as child at newpos
                var newClone = Instantiate(Model1, NewPos, Quaternion.Euler(RotationTemp));
                newClone.transform.parent = gameObject.transform;

                Modelisassigned = 1;
                Clonesexist = 1;
            }
        }

        //Reset new position to origin after script has run
        NewPos = Vector3.zero;
     
    }
	*/
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
