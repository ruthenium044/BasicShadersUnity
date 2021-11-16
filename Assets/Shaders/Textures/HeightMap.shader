Shader "Unlit/HeightMap"
{
    Properties
    {
        AlbedoTexture ("Texture", 2D) = "white" {}
        [NoScaleOffset] NormalMap ("NormalMap", 2D) = "bump" {}
        [NoScaleOffset] HeightMap ("HeightMap", 2D) = "gray" {}
        Gloss ("Gloss", Range(0, 1)) = 1
        NormalIntensity ("NormalIntensity", Range(0, 1)) = 1
        HeightIntensity ("HeightIntensity", Range(0, 1)) = 1
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
            #include "HeightMap.cginc"
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
            #include "HeightMap.cginc"
            ENDCG
        }
    }
}
