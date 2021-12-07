Shader "Custom/TexturesPacked"
{
    Properties
    {
        MainTint ("MainTint", Color) = (1,1,1,1)
        ColorA ("ColorA", Color) = (1,1,1,1)
        ColorB ("ColorB", Color) = (1,1,1,1)
     
        RTex ("RTex", 2D) = "" {}
        GTex ("GTex", 2D) = "" {}
        BTex ("BTex", 2D) = "" {}
        ATex ("ATex", 2D) = "" {}
        BlendTex ("BlendTex", 2D) = "" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uvRTex;    
            float2 uvGTex;    
            float2 uvBTex;    
            float2 uvATex;    
            float2 uvBlendTex;
        };

        float4 MainTint;
        float4 ColorA;
        float4 ColorB;
     
        sampler2D RTex;
        sampler2D GTex;
        sampler2D BTex;
        sampler2D ATex;
        sampler2D BlendTex;
        
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float4 blendData = tex2D(BlendTex, IN.uvBlendTex);
            float4 rTexData = tex2D(RTex, IN.uvATex);
            float4 gTexData = tex2D(GTex, IN.uvATex);
            float4 bTexData = tex2D(BTex, IN.uvATex);
            float4 aTexData = tex2D(ATex, IN.uvATex);

            float4 finalColor;
            finalColor = lerp(rTexData, gTexData, blendData.g);
            finalColor = lerp(finalColor, bTexData, blendData.b);
            finalColor = lerp(finalColor, aTexData, blendData.a);
            finalColor.a = 1;

            float4 layers = lerp(ColorA, ColorB, blendData.r);
            finalColor *= layers;
            finalColor = saturate(finalColor);

            o.Albedo = finalColor.rgb * MainTint.rgb;
            o.Alpha = finalColor.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
