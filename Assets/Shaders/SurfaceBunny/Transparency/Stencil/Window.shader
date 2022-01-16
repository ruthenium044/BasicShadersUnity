Shader "Custom/Window"
{
    Properties
    {
        MainColor ("Color", Color) = (1,1,1,1)
       
        StencilRef("Stencil Ref", Float) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)] StencilComp("StencilComp", Float) = 8 
        [Enum(UnityEngine.Rendering.StencilOp)] StencilOp("StencilOp", Float) = 2 
    }
    SubShader
    {
        Tags { "Queue"="Geometry-1" }
        LOD 200
        
        ZWrite off    
        ColorMask 0
        
        Stencil
        {
            Ref[StencilRef]
            Comp[StencilComp]
            Pass[StencilOp]
        }

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0
        
        struct Input
        {
            float2 uvMainTex;
        };

        sampler2D MainTex;
        fixed4 MainColor;
        
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (MainTex, IN.uvMainTex) * MainColor;
            o.Albedo = c.rgb;

            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
