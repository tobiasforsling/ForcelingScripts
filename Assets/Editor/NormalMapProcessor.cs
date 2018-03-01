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

        if (hasNormalID)
        {
            Debug.Log("_n. is found in filepath");
            TextureImporter textureImporter = (TextureImporter)assetImporter;
            textureImporter.textureType = TextureImporterType.NormalMap;
        }
    }
}
