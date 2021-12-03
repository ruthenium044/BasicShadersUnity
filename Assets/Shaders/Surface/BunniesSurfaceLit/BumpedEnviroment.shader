Shader "Custom/BumpedEnviroment"
{
    Properties
    {
        DiffuseTex ("DiffuseTex", 2D) = "white" {}
        NormalTex ("NormalTex", 2D) = "bump" {}
        BumpAmount ("BumpAmount", Range(0,10)) = 1
        Brightness ("Brightness", Range(0,10)) = 1
        CubeMap ("CubeMap", CUBE) = "white" {}
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
            float2 uvDiffuseTex;
            float2 uvNormalTex;
            float3 worldRefl; INTERNAL_DATA
        };

        sampler2D DiffuseTex;
        sampler2D NormalTex; 
        half BumpAmount;
        half Brightness;
        samplerCUBE CubeMap;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(DiffuseTex, IN.uvDiffuseTex).rgb;
            o.Normal = UnpackNormal(tex2D(NormalTex, IN.uvNormalTex)) * Brightness;
            o.Normal *= float3(BumpAmount, BumpAmount, 1);
            o.Emission = texCUBE(CubeMap, WorldReflectionVector(IN, o.Normal)).rgb;
            
        }
        ENDCG
    }
    FallBack "Diffuse"
}
