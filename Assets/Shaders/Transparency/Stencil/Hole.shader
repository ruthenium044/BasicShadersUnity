Shader "Custom/Hole"
{
    Properties
    {
        MainTex ("Albedo", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue"="Geometry-1" }
        LOD 200
        
        ColorMask 0
        ZWrite off
        
        Stencil
        {
            Ref 1 
            Comp always
            Pass replace
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

            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
