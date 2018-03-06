using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class ImportProcessor : AssetPostprocessor
{
    

    
    void OnPreprocessModel(GameObject model)
    {
        string lowerCaseAssetPath = assetPath.ToLower();
        bool hasFbxID = lowerCaseAssetPath.IndexOf(".fbx") != -1;

        if (hasFbxID)
        {
            Debug.Log(".fbx is found in filepath");
            //ModelImporter modelImporter = (ModelImporter)assetImporter;
            //modelImporter.ModelImporterMaterialLocation = ModelImporterMaterialLocation.External;
        }
    }

    void OnPostprocessTexture(Texture2D texture)
    {
        string lowerCaseAssetPath = assetPath.ToLower();
        bool hasSkyID = lowerCaseAssetPath.IndexOf("sky_") != -1;
        bool hasNormalID = lowerCaseAssetPath.IndexOf("_n.") != -1;

        if (hasSkyID)
        {
            Debug.Log("Sky_ is found in filepath");
            TextureImporter textureImporter = (TextureImporter)assetImporter;
            textureImporter.textureType = TextureImporterType.Default;
            textureImporter.textureShape = TextureImporterShape.TextureCube;
            textureImporter.wrapMode = TextureWrapMode.Repeat;
        }


        if (hasNormalID)
        {
            Debug.Log("_n. is found in filepath");
            TextureImporter textureImporter = (TextureImporter)assetImporter;
            textureImporter.textureType = TextureImporterType.NormalMap;
            //textureImporter.textureFormat = TextureImporterFormat.DXT5;
            //AssetImporter.SaveAndReimport; //Needs save and reimport to apply correct compression
            textureImporter.textureCompression = TextureImporterCompression.Compressed;
        }


    }
}
