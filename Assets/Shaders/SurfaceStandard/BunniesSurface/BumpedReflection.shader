Shader "Custom/BumpedReflection"
{
    Properties
    {
        NormalTex ("NormalTex", 2D) = "bump" {}
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
            float2 uvNormalTex;
            float3 worldRefl; INTERNAL_DATA
        };

        sampler2D DiffuseTex;
        sampler2D NormalTex; 

        samplerCUBE CubeMap;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Normal = UnpackNormal(tex2D(NormalTex, IN.uvNormalTex)) * 0.3;
            o.Albedo = texCUBE(CubeMap, WorldReflectionVector(IN, o.Normal)).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
