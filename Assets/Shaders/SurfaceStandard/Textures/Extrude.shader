Shader "Custom/Extrude"
{
    Properties
    {
        MainTex ("Albedo (RGB)", 2D) = "white" {}
        Baloon ("Baloon", Range(0, 0.3)) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert vertex:vert
        #pragma target 3.0

        struct Input
        {
            float2 uvMainTex;
        };

        float Baloon;
        
        struct appdata
        {
            float4 vertex: POSITION;
            float3 normal: NORMAL;
            float4 texcoord: TEXCOORD0;
        };

        void vert (inout appdata v)
        {
            v.vertex.xyz += v.normal * Baloon;
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
