Shader "Custom/Holorgram"
{
    Properties
    {
        RimColor ("RimColor", Color) = (1,1,1,1)
        RimStrength ("RimStrength", Range(0.5, 8)) = 3
    }
    SubShader
    {
        Tags { "Queue"="Transparent"     }
        LOD 200

        Pass 
        {
            ZWrite On
            ColorMask 0
        }
        
        CGPROGRAM
        #pragma surface surf Lambert alpha:fade
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
            o.Alpha = dotProduct;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
