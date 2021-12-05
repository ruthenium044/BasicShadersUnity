Shader "Custom/DotProduct"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
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
            float3 viewDir;
        };
        
        fixed4 RimColor;
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            half dotProduct = dot(IN.viewDir, o.Normal);
            o.Albedo = float3(dotProduct, 1, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
