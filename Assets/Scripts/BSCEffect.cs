using UnityEngine;

[ExecuteInEditMode]
public class BSCEffect : MonoBehaviour
{
    public Shader effectShader;
    private Material curMaterial;
    
    [Range(0.0f, 2.0f)] public float brightnessAmount = 1.0f;
    [Range(0.0f, 2.0f)] public float saturationAmount = 1.0f;
    [Range(0.0f, 2.0f)] public float contrastAmount = 1.0f;
    
    private static readonly int BrightnessAmount = Shader.PropertyToID("BrightnessAmount");
    private static readonly int SaturationAmount = Shader.PropertyToID("SaturationAmount");
    private static readonly int ContrastAmount = Shader.PropertyToID("ContrastAmount");

    Material material
    {
        get
        {
            if (curMaterial == null)
            {
                curMaterial = new Material(effectShader);
                curMaterial.hideFlags = HideFlags.HideAndDontSave;
            }
            return curMaterial;
        }
    }

    void Start()
    {
        if (effectShader && !effectShader.isSupported)
        {
            enabled = false;
        }
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (effectShader != null)
        {
            material.SetFloat(BrightnessAmount, brightnessAmount);
            material.SetFloat(SaturationAmount, saturationAmount);
            material.SetFloat(ContrastAmount, contrastAmount);
            Graphics.Blit(src, dest, material);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
    
    private void OnDisable()
    {
        if (curMaterial)
        {
            DestroyImmediate(curMaterial);
        }
    }
}
