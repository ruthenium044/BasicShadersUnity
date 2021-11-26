Shader "Custom/Surface"
{
    Properties
    {
        MainColor ("MainColor", Color) = (1,1,1,1)
        EmissionColor ("EmissionColor", Color) = (1,1,1,1)
        NormalColor ("NormalColor", Color) = (1,1,1,1)
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
            float2 uv_MainTex;
        };

        fixed4 MainColor;
        fixed4 EmissionColor;
        fixed4 NormalColor;
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Emission = EmissionColor.rgba;
            o.Albedo = MainColor.rgb;
            o.Normal = NormalColor.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
