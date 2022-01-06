Shader "Unlit/OldFilm"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        VignetteTex ("Vignette Texture", 2D) = "white"{}
        ScratchesTex ("Scartches Texture", 2D) = "white"{}
        DustTex ("Dust Texture", 2D) = "white"{}
        SepiaColor ("Sepia Color", Color) = (1,1,1,1)
        EffectAmount ("Old Film Effect Amount", Range(0,1)) = 1.0
        VignetteAmount ("Vignette Opacity", Range(0,1)) = 1.0
        ScratchesYSpeed ("Scratches Y Speed", Float) = 10.0
        ScratchesXSpeed ("Scratches X Speed", Float) = 10.0
        DustXSpeed ("Dust X Speed", Float) = 10.0
        DustYSpeed ("Dust Y Speed", Float) = 10.0
        RandomValue ("Random Value", Float) = 1.0
        Contrast ("Contrast", Float) = 3.0
        Distortion ("Distortion", Float) = 0.2
        Scale ("Scale (Zoom)", Float) = 0.8
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
            #include "UnityCG.cginc"
           
            sampler2D _MainTex;
            sampler2D VignetteTex;
            sampler2D ScratchesTex;
            sampler2D DustTex;
            fixed4 SepiaColor;
            fixed VignetteAmount;
            fixed ScratchesYSpeed;
            fixed ScratchesXSpeed;
            fixed DustXSpeed;
            fixed DustYSpeed;
            fixed EffectAmount;
            fixed RandomValue;
            fixed Contrast;
            fixed Distortion;
            fixed Scale;
            
            fixed4 frag (v2f_img i) : COLOR
            {
                fixed4 renderTex = tex2D(_MainTex, i.uv);
                fixed4 vignetteTex = tex2D(VignetteTex, i.uv);

                half2 scratchesUV = half2(i.uv.x + RandomValue * _SinTime.z * ScratchesXSpeed,
                                            i.uv.y + _Time.x * ScratchesYSpeed);
                fixed4 scratcesTex = tex2D(ScratchesTex, scratchesUV);

                half2 dustUV = half2(i.uv.x + RandomValue * _SinTime.z * DustXSpeed, 
                                        i.uv.y + RandomValue * _SinTime.z * DustYSpeed);
                fixed4 dustTex = tex2D(DustTex, dustUV);

                fixed lum = dot(fixed3(0.299, 0.587, 0.114), renderTex.rgb);
                fixed4 finalColor = lum + lerp(SepiaColor, SepiaColor + fixed4(0.1f, 0.1f, 0.1f, 0.1f), RandomValue);
                finalColor = pow(finalColor, Contrast);

                fixed3 constantWhite = fixed3(1, 1, 1);
                finalColor = lerp(finalColor, finalColor * vignetteTex, VignetteAmount);
                finalColor.rgb *= lerp(scratcesTex, constantWhite, RandomValue);
                finalColor.rgb *= lerp(dustTex.rgb, constantWhite, RandomValue * _SinTime.z);
                finalColor = lerp(renderTex, finalColor, EffectAmount);
                
                return finalColor;
            }
            ENDCG
        }
    }
}
