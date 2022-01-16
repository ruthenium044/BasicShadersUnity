Shader "Custom/Image"
{
    Properties
    {
        MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade
        #pragma target 3.0


        struct Input
        {
            float2 uvMainTex;
        };

        sampler2D MainTex;
   
        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (MainTex, IN.uvMainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
