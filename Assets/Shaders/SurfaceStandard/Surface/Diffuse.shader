Shader "Custom/Diffuse"
{
    Properties
    {
        MainColor ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };
        
        fixed4 MainColor;
        
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = MainColor.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
