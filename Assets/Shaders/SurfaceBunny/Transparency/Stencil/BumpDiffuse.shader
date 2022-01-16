Shader "Custom/BumpDiffuse"
{
    Properties
    {
        MainColor ("Color", Color) = (1,1,1,1)
        MainTexture ("MainTexture", 2D) = "white" {}
        BumpTexture ("BumpTexture", 2D) = "bump" {}
        BumpAmount ("BumpAmount", Range(0, 10)) = 1
       
        StencilRef("Stencil Ref", Float) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)] StencilComp("StencilComp", Float) = 8 
        [Enum(UnityEngine.Rendering.StencilOp)] StencilOp("StencilOp", Float) = 2 
    }
    SubShader
    {

        Stencil
        {
            Ref[StencilRef]
            Comp[StencilComp]
            Pass[StencilOp]
        }

        CGPROGRAM
        #pragma surface surf Lambert
        #pragma target 3.0
        
        struct Input
        {
            float2 uvMainTexture;
            float2 uvBumpTexture;
        };
        
        sampler2D MainTexture;
        sampler2D BumpTexture;
        fixed4 MainColor;
        float BumpAmount;
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D (MainTexture, IN.uvMainTexture).rgb * MainColor.rgb;
            o.Normal = UnpackNormal(tex2D(BumpTexture, IN.uvBumpTexture));
            o.Normal *= float3(BumpAmount, BumpAmount, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
