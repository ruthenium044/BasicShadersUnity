Shader "Custom/Radius"
{
    Properties
    {
        Center ("Center", Vector) = (0.5, 0.5, 0)
        Radius ("Radius", Float) = 1
        RadiusWidth ("RadiusWidth", Float) = 0.2
        MainColor ("Color", Color) = (1,1,1,1)
        MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0
        
        struct Input
        {
            float2 uvMainTex;
            float3 worldPos;
        };

        float3 Center;
        float Radius;
        float RadiusWidth;
        
        sampler2D MainTex;
        fixed4 MainColor;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float d = distance(Center, IN.worldPos);

            if ((d > Radius) && (d < (Radius + RadiusWidth)))
            {
                o.Albedo = MainColor;
            }
            else
            {
                o.Albedo = tex2D (MainTex, IN.uvMainTex);
            }
        }
        ENDCG
    }
    FallBack "Diffuse"
}
