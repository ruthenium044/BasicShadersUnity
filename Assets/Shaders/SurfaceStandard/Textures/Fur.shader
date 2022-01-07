Shader "Unlit/Fur"
{
    Properties
    {
        MainColor ("Color", Color) = (1,1,1,1)
        MainTex ("Albedo (RGB)", 2D) = "white" {}
        ControlTex ("Control Texture", 2D) = "white" {}
        Glossiness ("Smoothness", Range(0,1)) = 0.5
        Metallic ("Metallic", Range(0,1)) = 0.0
     
        FurLength ("Fur Length", Range (0.0002, 1)) = .25
        Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
        CutoffEnd ("Alpha cutoff end", Range(0,1)) = 0.5
        EdgeFade ("Edge Fade", Range(0,1)) = 0.4
        Gravity ("Gravity direction", Vector) = (0,0,1,0)
        GravityStrength ("G strenght", Range(0,1)) = 0.25
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0
        sampler2D MainTex;

        struct Input
        {
            float2 uvMainTex;
        };

        half Glossiness;
        half Metallic;
        fixed4 MainColor;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (MainTex, IN.uvMainTex) * MainColor;
            o.Albedo = c.rgb;
            o.Metallic = Metallic;
            o.Smoothness = Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
        
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
        #define FUR_MULTIPLIER 0.05
        #include "FurPass.cginc"
        ENDCG

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
        #define FUR_MULTIPLIER 0.1
        #include "FurPass.cginc"
        ENDCG
        
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
        #define FUR_MULTIPLIER 0.15
        #include "FurPass.cginc"
        ENDCG
        
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
        #define FUR_MULTIPLIER 0.2
        #include "FurPass.cginc"
        ENDCG

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
        #define FUR_MULTIPLIER 0.25
        #include "FurPass.cginc"
        ENDCG
        
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
        #define FUR_MULTIPLIER 0.3
        #include "FurPass.cginc"
        ENDCG

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
        #define FUR_MULTIPLIER 0.35
        #include "FurPass.cginc"
        ENDCG
        
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
        #define FUR_MULTIPLIER 0.4
        #include "FurPass.cginc"
        ENDCG
        
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
        #define FUR_MULTIPLIER 0.45
        #include "FurPass.cginc"
        ENDCG

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
        #define FUR_MULTIPLIER 0.5
        #include "FurPass.cginc"
        ENDCG
        
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
        #define FUR_MULTIPLIER 0.55
        #include "FurPass.cginc"
        ENDCG

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
        #define FUR_MULTIPLIER 0.6
        #include "FurPass.cginc"
        ENDCG
        
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
        #define FUR_MULTIPLIER 0.65
        #include "FurPass.cginc"
        ENDCG
        

        
    }
    FallBack "Diffuse"
}
