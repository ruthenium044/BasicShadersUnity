using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

[ExecuteInEditMode]
public class OldFilmEffect : MonoBehaviour
{
    [SerializeField] Shader effectShader;
    private Material curMaterial;
    
    [SerializeField] [Range(0, 1.5f)] float effectAmount = 1.0f;
 
    [SerializeField] Color sepiaColor = Color.white;
    [SerializeField] Texture2D vignetteTexture;
    [SerializeField] [Range(0, 1.0f)] float vignetteAmount = 1.0f;
    
    [SerializeField] Texture2D scratchesTexture;
    [SerializeField] float scratchesXSpeed = 10.0f;
    [SerializeField] float scratchesYSpeed = 10.0f;
    
    [SerializeField] Texture2D dustTexture;
    [SerializeField] float dustXSpeed = 10.0f;
    [SerializeField] float dustYSpeed = 10.0f;
    
    [SerializeField] [Range(-1f, 1f)] private float randomValue;
    
    private static readonly int SepiaColor = Shader.PropertyToID("SepiaColor");
    private static readonly int VignetteAmount = Shader.PropertyToID("VignetteAmount");
    private static readonly int VignetteTexture = Shader.PropertyToID("VignetteTexture");
    private static readonly int EffectAmount = Shader.PropertyToID("EffectAmount");
    private static readonly int ScratchesTex = Shader.PropertyToID("ScratchesTex");
    private static readonly int ScratchesYSpeed = Shader.PropertyToID("ScratchesYSpeed");
    private static readonly int ScratchesXSpeed = Shader.PropertyToID("ScratchesXSpeed");
    private static readonly int DustTex = Shader.PropertyToID("DustTex");
    private static readonly int DustYSpeed = Shader.PropertyToID("DustYSpeed");
    private static readonly int DustXSpeed = Shader.PropertyToID("DustXSpeed");
    private static readonly int RandomValue = Shader.PropertyToID("RandomValue");

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
            material.SetColor(SepiaColor, sepiaColor);
            material.SetFloat(VignetteAmount, vignetteAmount);
            material.SetFloat(EffectAmount, effectAmount);
            
            if(vignetteTexture)
            {
                material.SetTexture(VignetteTexture, vignetteTexture);
            }
 
            if(scratchesTexture)
            {
                material.SetTexture(ScratchesTex, scratchesTexture);
                material.SetFloat(ScratchesXSpeed, scratchesXSpeed);
                material.SetFloat(ScratchesYSpeed, scratchesYSpeed);
            }
 
            if(dustTexture)
            {
                material.SetTexture(DustTex, dustTexture);
                material.SetFloat(DustXSpeed, dustXSpeed);
                material.SetFloat(DustYSpeed, dustYSpeed);
                material.SetFloat(RandomValue, randomValue);
            }
            
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
