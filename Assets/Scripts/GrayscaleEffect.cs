using UnityEngine;

[ExecuteInEditMode]
public class GrayscaleEffect : MonoBehaviour
{
    public Shader curShader;
    [Range(0.0f, 1.0f)] public float grayScaleAmount = 1.0f;
    private Material curMaterial;
    private static readonly int LuminosityAmount = Shader.PropertyToID("LuminosityAmount");

    Material material
    {
        get
        {
            if (curMaterial == null)
            {
                curMaterial = new Material(curShader);
                curMaterial.hideFlags = HideFlags.HideAndDontSave;
            }
            return curMaterial;
        }
    }

    void Start()
    {
        if (curShader && !curShader.isSupported)
        {
            enabled = false;
        }
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (grayScaleAmount == 0)
        {
            Graphics.Blit(src, dest);
            return;
        }
        material.SetFloat(LuminosityAmount, grayScaleAmount);
        Graphics.Blit(src, dest, material);
    }
    
    private void OnDisable()
    {
        if (curMaterial)
        {
            DestroyImmediate(curMaterial);
        }
    }
}
