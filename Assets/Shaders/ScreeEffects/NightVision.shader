Shader "Unlit/NightVision"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        VignetteTex ("Vignette Texture", 2D) = "white"{}
        ScanLineTex ("Scan Line Texture", 2D) = "white"{}
        NoiseTex ("Noise Texture", 2D) = "white"{}
        NoiseXSpeed ("Noise X Speed", Float) = 100.0
        NoiseYSpeed ("Noise Y Speed", Float) = 100.0
        ScanLineTileAmount ("Scan Line Tile Amount", Float) = 4.0
        NightVisionColor ("Night Vision Color", Color) = (1,1,1,1)
        Contrast ("Contrast", Range(0,4)) = 2
        Brightness ("Brightness", Range(0,2)) = 1
        RandomValue ("Random Value", Float) = 0
        Distortion ("Distortion", Float) = 0.2
        Scale ("Scale (Zoom)", Float) = 0.8
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
            #include "UnityCG.cginc"
             
            uniform sampler2D _MainTex;
            uniform sampler2D VignetteTex;
            uniform sampler2D ScanLineTex;
            uniform sampler2D NoiseTex;
            fixed4 NightVisionColor;
            fixed Contrast;
            fixed ScanLineTileAmount;
            fixed Brightness;
            fixed RandomValue;
            fixed NoiseXSpeed;
            fixed NoiseYSpeed;
            fixed Distortion;
            fixed Scale;

            float2 barrelDistortion(float2 coord)
            {
                // lens distortion algorithm
                // See http://www.ssontech.com/content/lensalg.htm
                float2 h = coord.xy - float2(0.5, 0.5);
                float r2 = h.x * h.x + h.y * h.y;
                float f = 1.0 + r2 * (Distortion * sqrt(r2));
                return f * Scale * h + 0.5;
            }
            
            fixed4 frag (v2f_img i) : COLOR
            {
                half2 distortedUV = barrelDistortion(i.uv);
                fixed4 renderTex = tex2D(_MainTex, distortedUV);
                fixed4 vignetteTex = tex2D(VignetteTex, i.uv);

                half2 scanLinesUV = half2(i.uv.x * ScanLineTileAmount, i.uv.y * ScanLineTileAmount);
                fixed4 scanLineTex = tex2D(ScanLineTex, scanLinesUV);
 
                half2 noiseUV = half2(i.uv.x + RandomValue * _SinTime.z * NoiseXSpeed,
                                        i.uv.y + _Time.x * NoiseYSpeed);
                fixed4 noiseTex = tex2D(NoiseTex, noiseUV);

                fixed lum = dot (fixed3(0.299, 0.587, 0.114), renderTex.rgb);
                lum += Brightness;
                fixed4 finalColor = lum * 2 + NightVisionColor;
                
                finalColor = pow(finalColor, Contrast);
                finalColor *= vignetteTex;
                finalColor *= scanLineTex * noiseTex;
                return finalColor;
            }
            ENDCG
        }
    }
}
