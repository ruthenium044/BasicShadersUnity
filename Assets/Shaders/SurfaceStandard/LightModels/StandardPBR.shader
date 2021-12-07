Shader "Custom/StandardPBR"
{
    Properties
    {
        MainColor ("Color", Color) = (1,1,1,1)
        MetallicTexture ("MetallicTexture", 2D) = "white" {}
        Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard
        #pragma target 3.0
        
        struct Input
        {
            float2 uvMetallicTexture;
        };

        sampler2D MetallicTexture;
        half Metallic;
        fixed4 MainColor;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = MainColor.rgb;
            o.Smoothness = tex2D (MetallicTexture, IN.uvMetallicTexture).r;
            o.Metallic = Metallic;
        
        }
        ENDCG
    }
    FallBack "Diffuse"
}
