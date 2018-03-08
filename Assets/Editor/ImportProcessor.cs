using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class ImportProcessor : AssetPostprocessor
{
    void OnPreprocessModel()
    {
        string lowerCaseAssetPath = assetPath.ToLower();
        bool hasFbxID = lowerCaseAssetPath.IndexOf(".fbx") != -1;

        ModelImporter FbxImporter = (ModelImporter)assetImporter;
        
        //IMPORTING .FBX FILES WITH LEGACY MATERIAL METHOD
        if (hasFbxID)
        {
            //Debug.Log(".fbx is found in filepath");
            FbxImporter.materialLocation = ModelImporterMaterialLocation.External;
        }
    }

    void OnPreprocessTexture()
    {
        string lowerCaseAssetPath = assetPath.ToLower();
        bool hasNormalID = lowerCaseAssetPath.IndexOf("_n.") != -1;
        bool hasSkyID = lowerCaseAssetPath.IndexOf("sky_") != -1;

        TextureImporter NormalImporter = (TextureImporter)assetImporter;
        TextureImporter SkyImporter = (TextureImporter)assetImporter;

        //IMPORTING "_N." AS NORMAL MAPS
        if (hasNormalID && NormalImporter.textureType != TextureImporterType.NormalMap)
        {
            NormalImporter.textureType = TextureImporterType.NormalMap;
            //Debug.Log("_n. is found in filepath, file type changed");
        }

        //IMPORTING "SKY_" FILES AS CUBEMAPS WITH REPEATING WRAPMODE
        if (hasSkyID)
        {
            //Debug.Log("Sky_ is found in filepath, file type and shape changed");
            SkyImporter.textureType = TextureImporterType.Default;
            SkyImporter.textureShape = TextureImporterShape.TextureCube;
            SkyImporter.wrapMode = TextureWrapMode.Repeat;
        }
    }
}
