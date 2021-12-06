Shader "Custom/Holorgram1"
{
    Properties
    {
        RimColor ("RimColor", Color) = (1,1,1,1)
        DotProduct ("RimStrength", Range(-1, 1)) = 0.5
    }
    SubShader
    {
        Tags { "Queue"="Transparent"}
        LOD 200

        Cull Back
        
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
            float3 worldNormal;
            float3 viewDir;
        };
        
        fixed4 RimColor;
        float RimStrength;
        float DotProduct;
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            float4 col = RimColor;
            o.Albedo = col.rgb;
            
            float border = 1 - abs(dot(IN.viewDir, IN.worldNormal));
            float alpha = border * (1 - DotProduct) + DotProduct;
           
            o.Alpha = alpha * col.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
