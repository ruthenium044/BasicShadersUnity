Shader "Unlit/NormalMap"
{
    Properties
    {
        AlbedoTexture ("Texture", 2D) = "white" {}
        [NoScaleOffset] NormalMap ("Texture", 2D) = "bump" {}
        Gloss ("Gloss", Range(0, 1)) = 1
        NormalIntensity ("NormalIntensity", Range(0, 1)) = 1
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
            #include "NormalMap.cginc"
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
            #include "NormalMap.cginc"
            ENDCG
        }
    }
}
