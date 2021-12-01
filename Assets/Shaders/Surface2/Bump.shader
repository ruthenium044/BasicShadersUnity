Shader "Custom/Bump"
{
    Properties
    {
        DiffuseTex ("DiffuseTex", 2D) = "white" {}
        NormalTex ("NormalTex", 2D) = "bump" {}
        Slider("Slider", Range(0, 5)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D DiffuseTex;
        sampler2D NormalTex;
        half Slider;

        struct Input
        {
            float2 uvDiffuseTex;
            float2 uvNormalTex;
        };
        
        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = tex2D (DiffuseTex, IN.uvDiffuseTex).rgb;
            o.Normal = UnpackNormal(tex2D (NormalTex, IN.uvNormalTex));
            o.Normal *= float3(Slider, Slider, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
