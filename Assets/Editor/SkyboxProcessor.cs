using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class SkyboxProcessor : AssetPostprocessor
{
/*
    void OnPostprocessTexture(Texture2D texture)
    {
        string lowerCaseAssetPath = assetPath.ToLower();
        bool hasSkyID = lowerCaseAssetPath.IndexOf("Sky_") != -1;

        if (hasSkyID)
        {
            Debug.Log("Sky_ is found in filepath");
            TextureImporter textureImporter = (TextureImporter)assetImporter;
            textureImporter.textureShape = TextureImporterShape.TextureCube;
        }
    }*/
}