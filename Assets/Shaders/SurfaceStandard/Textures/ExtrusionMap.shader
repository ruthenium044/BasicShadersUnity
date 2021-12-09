Shader "Custom/ExtrusionMap"
{
    Properties
    {
        MainTex ("Albedo (RGB)", 2D) = "white" {}
        ExtrusionTex ("ExtrusionTex", 2D) = "white" {}
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
        sampler2D ExtrusionTex;
        
        void vert (inout appdata_full v)
        {
            float4 tex = tex2Dlod(ExtrusionTex, float4(v.texcoord.xy, 0,0 ));
            float extrusion = tex.r * 2 - 1;
            v.vertex.xyz += v.normal * Balloon * extrusion;
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
