using System;
using UnityEngine;

[ExecuteInEditMode]
public class BlendEffect : MonoBehaviour
{
    public Shader effectShader;
    private Material curMaterial;
    
    [Range(0.0f, 2.0f)] public float blendOpacity = 1.0f;
    public Texture2D blendTexture;

    private readonly String[] keywords = {"_OVERLAY_NONE", "_OVERLAY_MULTIPLY", "_OVERLAY_ADD", "_OVERLAY_SCREEN", "_OVERLAY_OVERLAY"};
    enum BlendModes
    {
        None,
        Multiply,
        Add,
        Screen,
        Overlay
    }
    [SerializeField] private BlendModes blendMode = 0;
    
    private static readonly int BlendTex = Shader.PropertyToID("BlendTex");
    private static readonly int Opacity = Shader.PropertyToID("Opacity");

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
            material.SetTexture(BlendTex, blendTexture);
            material.SetFloat(Opacity, blendOpacity);
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

    private void Update()
    {
        SetMode();
    }

    private void SetMode()
    {
        DeactivateAllKeywords();
        Shader.EnableKeyword(keywords[(int)blendMode]);
    }
    
    private void DeactivateAllKeywords()
    {
        for (int i = 0; i < keywords.Length; i++)
        {
            Shader.DisableKeyword(keywords[i]);
        }
    }
}
