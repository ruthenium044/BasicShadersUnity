Shader "Custom/StandardSpecPBR"
{
    Properties
    {
        MainColor ("Color", Color) = (1,1,1,1)
        MetallicTexture ("MetallicTexture", 2D) = "white" {}
        _SpecColor ("SpecColor", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf StandardSpecular
        #pragma target 3.0
        
        struct Input
        {
            float2 uvMetallicTexture;
        };

        sampler2D MetallicTexture;
        fixed4 MainColor;

        void surf (Input IN, inout SurfaceOutputStandardSpecular o)
        {
            o.Albedo = MainColor.rgb;
            o.Smoothness = tex2D (MetallicTexture, IN.uvMetallicTexture).r;
            o.Specular = _SpecColor;
        
        }
        ENDCG
    }
    FallBack "Diffuse"
}
