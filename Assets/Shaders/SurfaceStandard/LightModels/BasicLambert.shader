Shader "Custom/BasicLambert"
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
        #pragma surface surf BasicLambert

        half4 LightingBasicLambert (SurfaceOutput o, half3 lightDir, half atten)
        {
            half NdotL = dot(o.Normal, lightDir);
            half4 c;
            c.rgb = o.Albedo * _LightColor0.rgb * (NdotL * atten);
            c.a = o.Alpha;
            return c;
        }
        
        struct Input
        {
            float2 uv_MainTex;
        };
        
        fixed4 MainColor;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = MainColor.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
