Shader "Custom/Textures"
{
    Properties
    {
        MainTexture ("MainTexture", 2D) = "white" {}
        EmissionTexture ("EmissionTexture", 2D) = "black" {}
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
        sampler2D EmissionTexture;
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(MainTexture, IN.uvMainTexture).rgb;
            o.Emission = tex2D(EmissionTexture, IN.uvMainTexture).rgb;
            
        }
        ENDCG
    }
    FallBack "Diffuse"
}
