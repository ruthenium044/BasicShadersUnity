Shader "Custom/RimLight"
{
    Properties
    {
        RimColor ("RimColor", Color) = (1,1,1,1)
        RimStrength ("RimStrength", Range(0.5, 8)) = 3
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
        float RimStrength;
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            half dotProduct = 1 - saturate(dot(normalize(IN.viewDir), o.Normal));
            dotProduct = pow(dotProduct, RimStrength);
            o.Emission = RimColor * dotProduct;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
