using System;
using UnityEngine;

[ExecuteInEditMode]
public class BlendEffect : MonoBehaviour
{
    public Shader effectShader;
    private Material curMaterial;
    
    [Range(0.0f, 2.0f)] public float blendOpacity = 1.0f;
    public Texture2D blendTexture;

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
        Debug.Log(Shader.globalKeywords[53]);
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
        switch (blendMode)
        {
            case BlendModes.None:
                Shader.EnableKeyword("_OVERLAY_NONE");
                Shader.DisableKeyword("_OVERLAY_MULTIPLY");
                Shader.DisableKeyword("_OVERLAY_ADD");
                Shader.DisableKeyword("_OVERLAY_SCREEN");
                Shader.DisableKeyword("_OVERLAY_OVERLAY");
                break;
            case BlendModes.Multiply:
                Shader.DisableKeyword("_OVERLAY_NONE");
                Shader.EnableKeyword("_OVERLAY_MULTIPLY");
                Shader.DisableKeyword("_OVERLAY_ADD");
                Shader.DisableKeyword("_OVERLAY_SCREEN");
                Shader.DisableKeyword("_OVERLAY_OVERLAY");
                break;
            case BlendModes.Add:
                Shader.DisableKeyword("_OVERLAY_NONE");
                Shader.DisableKeyword("_OVERLAY_MULTIPLY");
                Shader.EnableKeyword("_OVERLAY_ADD");
                Shader.DisableKeyword("_OVERLAY_SCREEN");
                Shader.DisableKeyword("_OVERLAY_OVERLAY");
                break;
            case BlendModes.Screen:
                Shader.DisableKeyword("_OVERLAY_NONE");
                Shader.DisableKeyword("_OVERLAY_MULTIPLY");
                Shader.DisableKeyword("_OVERLAY_ADD");
                Shader.EnableKeyword("_OVERLAY_SCREEN");
                Shader.DisableKeyword("_OVERLAY_OVERLAY");
                break;
            case BlendModes.Overlay:
                Shader.DisableKeyword("_OVERLAY_NONE");
                Shader.DisableKeyword("_OVERLAY_MULTIPLY");
                Shader.DisableKeyword("_OVERLAY_ADD");
                Shader.DisableKeyword("_OVERLAY_SCREEN");
                Shader.EnableKeyword("_OVERLAY_OVERLAY");
                break;
            default:
                throw new ArgumentOutOfRangeException();
        }
    }
}
