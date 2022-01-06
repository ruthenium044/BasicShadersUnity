using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class NightVisionEffect : MonoBehaviour
{
    [SerializeField] Shader effectShader;
    private Material curMaterial;
    
    [SerializeField] float contrast = 2.0f;
    [SerializeField] float brightness = 1.0f;
    [SerializeField] Color nightVisionColor = Color.white;
    
    [SerializeField] Texture2D vignetteTexture;
  
    [SerializeField] Texture2D scanLineTexture;
    [SerializeField] float scanLineTileAmount = 4.0f;
  
    [SerializeField] Texture2D nightVisionNoise;
    [SerializeField] float noiseXSpeed = 100.0f;
    [SerializeField] float noiseYSpeed = 100.0f;
    
    [SerializeField] float distortion = 0.2f;
    [SerializeField] float scale = 0.8f;
    
    private float randomValue = 0f;
    
    private static readonly int Contrast = Shader.PropertyToID("Contrast");
    private static readonly int Brightness = Shader.PropertyToID("Brightness");
    private static readonly int NightVisionColor = Shader.PropertyToID("NightVisionColor");
    private static readonly int RandomValue = Shader.PropertyToID("RandomValue");
    private static readonly int Distortion = Shader.PropertyToID("Distortion");
    private static readonly int Scale = Shader.PropertyToID("Scale");
    private static readonly int VignetteTex = Shader.PropertyToID("VignetteTex");
    private static readonly int ScanLineTex = Shader.PropertyToID("ScanLineTex");
    private static readonly int ScanLineTileAmount = Shader.PropertyToID("ScanLineTileAmount");
    private static readonly int NoiseTex = Shader.PropertyToID("NoiseTex");
    private static readonly int NoiseXSpeed = Shader.PropertyToID("NoiseXSpeed");
    private static readonly int NoiseYSpeed = Shader.PropertyToID("NoiseYSpeed");

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
            material.SetFloat(Contrast, contrast);
            material.SetFloat(Brightness, brightness);
            material.SetColor(NightVisionColor, nightVisionColor);
            material.SetFloat(RandomValue, randomValue);
            material.SetFloat(Distortion, distortion);
            material.SetFloat(Scale, scale);
            
            if(vignetteTexture)
            {
                material.SetTexture(VignetteTex, vignetteTexture);
            }
 
            if(scanLineTexture)
            {
                material.SetTexture(ScanLineTex, scanLineTexture);
                material.SetFloat(ScanLineTileAmount, scanLineTileAmount);
            }
 
            if(nightVisionNoise)
            {
                material.SetTexture(NoiseTex, nightVisionNoise);
                material.SetFloat(NoiseXSpeed, noiseXSpeed);
                material.SetFloat(NoiseYSpeed, noiseYSpeed);
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
