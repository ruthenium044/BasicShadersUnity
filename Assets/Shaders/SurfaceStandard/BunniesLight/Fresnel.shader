Shader "Custom/Fresnel"
{
    Properties
    {
        MainColor ("MainColor", Color) = (1,1,1,1)
        _SpecColor ("SpecularColor", Color) = (1,1,1,1)
        SpecularStr ("SpecularStrength", Range(0,1)) = 0.5
        Glossiness ("Glossiness", Range(0,1)) = 0.5
        
        FresnelColor ("FresnelColor", Color) = (1,1,1,1)
        FresnelStrength ("FresnelStrength", Range(0.25, 4)) = 0.5
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
            float3 worldNormal;
            float3 viewDir;
        };
        
        half Glossiness;
        half SpecularStr;
        half FresnelStrength;
        
        fixed4 MainColor;
        fixed4 FresnelColor;
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = MainColor.rgb;
            o.Specular = SpecularStr;
            o.Gloss = Glossiness;

            float fresnel = dot(IN.worldNormal, IN.viewDir);
            fresnel = saturate(1 - fresnel);
            fresnel = pow(fresnel, FresnelStrength);
            o.Emission = fresnel * FresnelColor;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
