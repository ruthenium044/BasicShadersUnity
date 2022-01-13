Shader "Custom/Extrude"
{
    Properties
    {
        MainTex ("Albedo (RGB)", 2D) = "white" {}
        Balloon ("Balloon", Range(0, 0.3)) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Cull Off
        
        CGPROGRAM
        #pragma surface surf Lambert vertex:vert
        #pragma target 3.0

        struct Input
        {
            float2 uvMainTex;
        };

        float Balloon;

        void vert (inout appdata_full v)
        {
            v.vertex.xyz += v.normal * Balloon;
        }
        
        sampler2D MainTex;
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (MainTex, IN.uvMainTex);
            o.Albedo = c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
