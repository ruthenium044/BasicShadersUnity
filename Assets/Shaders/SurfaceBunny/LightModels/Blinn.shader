Shader "Custom/Blinn"
{
    Properties
    {
        MainColor ("MainColor", Color) = (1,1,1,1)
        _SpecColor ("SpecularColor", Color) = (1,1,1,1)
        SpecularStr ("SpecularStrength", Range(0,1)) = 0.5
        Glossiness ("Glossiness", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "Queue"="Geometry" }
        LOD 200

        CGPROGRAM
        #pragma surface surf BlinnPhong
        #pragma target 3.0

        struct Input
        {
            float2 uvMainTex;
        };
        
        half Glossiness;
        half SpecularStr;
        
        fixed4 MainColor;
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = MainColor.rgb;
            o.Specular = SpecularStr;
            o.Gloss = Glossiness;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
