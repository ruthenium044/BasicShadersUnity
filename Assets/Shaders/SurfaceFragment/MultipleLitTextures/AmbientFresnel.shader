Shader "Unlit/AmbientFresnel"
{
    Properties
    {
        AlbedoTexture ("Texture", 2D) = "white" {}
        
        [NoScaleOffset] NormalMap ("NormalMap", 2D) = "bump" {}
        [NoScaleOffset] HeightMap ("HeightMap", 2D) = "gray" {}
        [NoScaleOffset] SpecularIBL ("SpecularIBL", 2D) = "black" {}
        
        NormalIntensity ("NormalIntensity", Range(0, 1)) = 1
        HeightIntensity ("HeightIntensity", Range(0, 1)) = 1
        SpecularIntensity ("SpecularIntensity", Range(0, 1)) = 1
        
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
            #include "AmbientFresnel.cginc"
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
            #include "AmbientFresnel.cginc"
            ENDCG
        }
    }
}
