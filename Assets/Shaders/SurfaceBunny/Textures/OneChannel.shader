Shader "Custom/OneChannel"
{
    Properties
    {
        MainTexture ("MainTexture", 2D) = "white" {}
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
            float2 uvMainTexture;
            float3 worldReflection;
        };
        
        sampler2D MainTexture;
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 green = fixed4 (0, 1, 0, 1);
            o.Albedo = tex2D(MainTexture, IN.uvMainTexture).rgb * green;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
