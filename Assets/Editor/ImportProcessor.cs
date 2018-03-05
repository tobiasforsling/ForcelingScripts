using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class ImportProcessor : AssetPostprocessor
{
    /*
    string lowerCaseAssetPath = assetPath.ToLower();

    void OnPostprocessModel()
    {


        if (hasFbxID)
        {
            //Debug.Log(".fbx is found in filepath");
            ModelImporter modelimporter = (ModelImporter)assetImporter;
            ModelImporter.mat = TextureImporterType.Default;
            textureImporter.textureShape = TextureImporterShape.TextureCube;
            textureImporter.wrapMode = TextureWrapMode.Repeat;
        }
    }
    */

    void OnPostprocessTexture(Texture2D texture)
    {
        bool hasNormalID = lowerCaseAssetPath.IndexOf("_n.") != -1;
        bool hasSkyID = lowerCaseAssetPath.IndexOf("sky_") != -1;
        bool hasFbxID = lowerCaseAssetPath.IndexOf(".fbx1") != -1;

        if (hasSkyID)
        {
            //Debug.Log("Sky_ is found in filepath");
            TextureImporter textureImporter = (TextureImporter)assetImporter;
            textureImporter.textureType = TextureImporterType.Default;
            textureImporter.textureShape = TextureImporterShape.TextureCube;
            textureImporter.wrapMode = TextureWrapMode.Repeat;
        }

        if (hasNormalID)
        {
            //Debug.Log("_n. is found in filepath");
            TextureImporter textureImporter = (TextureImporter)assetImporter;
            textureImporter.textureType = TextureImporterType.NormalMap;
        }


    }
}
