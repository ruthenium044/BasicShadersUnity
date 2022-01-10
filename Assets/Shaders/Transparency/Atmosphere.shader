Shader "Custom/Atmosphere"
{
    Properties
    {
        MainColor ("Color", Color) = (1,1,1,1)
        MainTex ("Albedo (RGB)", 2D) = "white" {}
        Thickness ("Thickness", Range(-1,1)) = 0.5
        AtmosColor (" Atmosphere Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" = "Transparent" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D MainTex;
        fixed4 MainColor;

        struct Input
        {
            float2 uvMainTex;
        };
        
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (MainTex, IN.uvMainTex) * MainColor;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
        
        Cull Front
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha vertex:vert
        struct Input
        {
            float2 uvMainTex;
        };
        
        float Thickness;
        fixed4 AtmosColor;
        
        void vert (inout appdata_full v)
        {
            v.vertex.xyz += v.normal * Thickness;
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = AtmosColor.rgb;
            o.Alpha = AtmosColor.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
