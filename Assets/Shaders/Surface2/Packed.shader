Shader "Custom/Packed"
{
    Properties
    {
        MainColor ("MainColor", Color) = (1,1,1,1)
        SomeRange ("Range", Range(0,5)) = 0
        MainTexture ("MainTexture", 2D) = "white" {}
        SkyCube ("SkyCube", CUBE) = "" {}
        Floats ("Float", float) = 0
        Vectorz ("Vector", Vector) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert 
        #pragma target 3.0

        struct Input
        {
            float2 uvMainTexture;
            float3 worldReflection;
        };

        fixed4 MainColor; 
        float SomeRange; 
        sampler2D MainTexture;
        samplerCUBE SkyCube;
        float Floats;
        float4 Vectorz;
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = (tex2D(MainTexture, IN.uvMainTexture) * SomeRange * MainColor).rgb;
            o.Emission = texCUBE(SkyCube, IN.worldReflection).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
