Shader "Custom/Outline"
{
    Properties
    {
        MainTexture ("MainTexture", 2D) = "white" {}
        OutlineColor ("OutlineColor", Color) = (1,1,1,1)
        OutlineWidth ("OutlineWidth", Range(0.02, 0.1)) = 0.05
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        
        Cull off
        ZWrite off
        CGPROGRAM
        #pragma surface surf Lambert vertex:vert

        struct Input
        {
            float2 uvMainTexture;
        };

        fixed4 OutlineColor;
        float OutlineWidth;
        
        void vert (inout appdata_full v)
        {
            v.vertex.xyz += v.normal * OutlineWidth;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Emission = OutlineColor.rgb;
        }
        
        ENDCG

        ZWrite on
        CGPROGRAM
        #pragma surface surf Lambert 
        #pragma target 3.0

        struct Input
        {
            float2 uvMainTexture;
        };
        
        sampler2D MainTexture;
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(MainTexture, IN.uvMainTexture).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
