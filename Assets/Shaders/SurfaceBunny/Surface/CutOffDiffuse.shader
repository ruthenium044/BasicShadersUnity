Shader "Custom/CutOffDiffuse"
{
    Properties
    {
        DiffuseTexture ("DiffuseTexture", 2D) = "white" {}
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
            float2 uvDiffuseTexture;
        };

        sampler2D DiffuseTexture;
        fixed4 RimColor;
        float RimStrength;
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            half dotProduct = 1 - saturate(dot(normalize(IN.viewDir), o.Normal));
            dotProduct = dotProduct > 0.5 ? RimColor : 0;
            o.Emission = RimColor * dotProduct;
            o.Albedo = (tex2D(DiffuseTexture, IN.uvDiffuseTexture)).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
