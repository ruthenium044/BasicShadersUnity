Shader "Custom/Wall"
{
    Properties
    {
        MainTex ("MainTex", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        
        Stencil
        {
            Ref 1
            Comp notequal
            Pass keep
        }

        CGPROGRAM
        #pragma surface surf Lambert
        #pragma target 3.0

        struct Input
        {
            float2 uvMainTex;
        };
        
        sampler2D MainTex;

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(MainTex, IN.uvMainTex);
            o.Albedo = c.rgb;
            
        }
        ENDCG
    }
    FallBack "Diffuse"
}
