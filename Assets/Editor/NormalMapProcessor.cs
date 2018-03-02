using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class NormalMapProcessor : AssetPostprocessor
{

    void OnPostprocessTexture(Texture2D texture)
    {
        string lowerCaseAssetPath = assetPath.ToLower();
        bool hasNormalID = lowerCaseAssetPath.IndexOf("_n.") != -1;
        bool hasSkyID = lowerCaseAssetPath.IndexOf("sky_") != -1;

        if (hasSkyID)
        {
            Debug.Log("Sky_ is found in filepath");
            TextureImporter textureImporter = (TextureImporter)assetImporter;
            textureImporter.textureType = TextureImporterType.Default;
            textureImporter.textureShape = TextureImporterShape.TextureCube;
        }

        if (hasNormalID)
        {
            Debug.Log("_n. is found in filepath");
            TextureImporter textureImporter = (TextureImporter)assetImporter;
            textureImporter.textureType = TextureImporterType.NormalMap;
        }
    }
}
