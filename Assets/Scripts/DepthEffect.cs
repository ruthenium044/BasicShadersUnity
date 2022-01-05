using UnityEngine;

[ExecuteInEditMode]
public class DepthEffect : MonoBehaviour
{
    public Shader curShader;
    [Range(0.0f, 1.0f)] public float depthPower = 1.0f;
    private Material curMaterial;
    private static readonly int DepthPower = Shader.PropertyToID("DepthPower");

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
        if (curShader != null)
        {
            material.SetFloat(DepthPower, depthPower);
            Graphics.Blit(src, dest, material);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
        
    }

    private void Update()
    {
        if (Camera.main != null) Camera.main.depthTextureMode = DepthTextureMode.Depth;
    }

    private void OnDisable()
    {
        if (curMaterial)
        {
            DestroyImmediate(curMaterial);
        }
    }
}
