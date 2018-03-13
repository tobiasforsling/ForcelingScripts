using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ForcelingInstance: MonoBehaviour {
    public GameObject Model1;
    public Vector3 InitialOffset;
    public Vector3 Offset;
    public Vector3 Rotation;
    [HideInInspector]
    public Vector3 RotationTemp;
    [HideInInspector]
    public Vector3 RotationNew;
    [HideInInspector]
    public Vector3 NewPos;
    [HideInInspector]
    public static int Clonesexist = 3; //1=yes 2=no 3=unknown
    [HideInInspector]
    public static int Modelisassigned = 3; //1=yes 2=no 3=unknown
    public static int Multipleobjects = 3; //1=yes 2=no 3=unknown
    public int NumberofClones;
    public bool UseRandomRotation = false;

    public void CalculateRandomRot()
    {
        //Use a random factor that user gives that affects the actual rotation values
        RotationTemp = new Vector3(Random.Range(0, Rotation.x), Random.Range(0, Rotation.y), Random.Range(0, Rotation.z));
    }

    public void Buildobject()
    {
        NewPos += InitialOffset;

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
                //Checks if its supposed to spawn using random rotation or not
                if(UseRandomRotation == true)
                {
                    //Applying offset to Newpos
                    NewPos += Offset;

                    //Calculation Random rotation
                    RotationNew = new Vector3(Random.Range(0, Rotation.x), Random.Range(0, Rotation.y), Random.Range(0, Rotation.z));

                    //Create clone as child at newpos
                    var newClone = Instantiate(Model1, NewPos, Quaternion.Euler(RotationNew));
                    newClone.transform.parent = gameObject.transform;

                    Modelisassigned = 1;
                    Clonesexist = 1;
                }
                else
                {
                    //Applying offset to Newpos
                    NewPos += Offset;

                    //Create clone as child at newpos
                    var newClone = Instantiate(Model1, NewPos, Quaternion.identity);
                    newClone.transform.parent = gameObject.transform;

                    Modelisassigned = 1;
                    Clonesexist = 1;
                }

            }
        }

        //Reset new position to origin after script has run
        NewPos = Vector3.zero;
     
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
