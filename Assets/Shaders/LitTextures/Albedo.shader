Shader "Unlit/Albedo"
{
    Properties
    {   
        AlbedoTexture ("Texture", 2D) = "white" {}
        Gloss ("Gloss", Range(0, 1)) = 1
        SurfaceColor ("SurfaceColor", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define IS_BASE_PASS
            #include "LitTextures.cginc"
            ENDCG
        }
        
        Pass
        {
            Tags { "LightMode" = "ForwardAdd" }
            Blend One One
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdadd
            #include "LitTextures.cginc"
            ENDCG
        }
    }
}
