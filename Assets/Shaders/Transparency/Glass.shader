Shader "Custom/Glass"
{
    Properties
    {
        MainColor ("Color", Color) = (1,1,1,1)
        MainTex ("Albedo (RGB)", 2D) = "white" {}
        Glossiness ("Smoothness", Range(0,1)) = 0.5
        Metallic ("Metallic", Range(0,1)) = 0.0
        Thickness ("Thickness", Range(-1,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" = "Transparent"    }
        LOD 200
        Cull Back

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha vertex:vert
        #pragma target 3.0

        sampler2D MainTex;
        half Glossiness;
        half Metallic;
        fixed4 MainColor;
        float Thickness;

        struct Input
        {
            float2 uvMainTex;
        };

        void vert (inout appdata_full v)
        {
            v.vertex.xyz += v.normal * Thickness;
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (MainTex, IN.uvMainTex) * MainColor;
            o.Albedo = c.rgb;
            o.Metallic = Metallic;
            o.Smoothness = Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
