Shader "Custom/ScrollingTextures"
{
    Properties
    {
        ColorA ("ColorA", Color) = (1, 1, 1, 1)
        MainTex ("MainTex", 2D) = "white" {}
        FoamTex ("FoamTex", 2D) = "white" {}
        Scroll ("Scroll", Float) = 1
    }
    SubShader
    {
        Lighting Off
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert

        float4 ColorA;
        sampler2D MainTex;
        sampler2D FoamTex;
        float Scroll;
        
        struct Input
        {
            float2 uvMainTex;
            float2 uvFoamTex;
        };
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            Scroll *= _Time.y;
            float3 water = tex2D(MainTex, IN.uvMainTex + float2(Scroll, Scroll)).rgb * 1.5;
            float3 foam = tex2D(FoamTex, IN.uvFoamTex + float2(Scroll / 2, Scroll / 2)).rgb;     
            o.Albedo.rgb = (water + foam) * ColorA;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
