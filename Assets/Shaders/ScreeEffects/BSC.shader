Shader "Unlit/BSC"
{
   Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        BrightnessAmount ("Brightness Amount", Range(0, 1)) = 1
        SaturationAmount ("Saturation Amount", Range(0, 1)) = 1
        ContrastAmount ("Contrast Amount", Range(0, 1)) = 1
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

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            fixed BrightnessAmount;
            fixed SaturationAmount;
            fixed ContrastAmount;

            float3 ContrastSaturationBrightness(float3 color, float brt, float sat, float con)
            {
                float3 luminanceCoeff = float3(0.2125, 0.7154, 0.0721);
                float3 avgLum = float3(0.5f, 0.5f, 0.5f);
                
                float3 brtColor = color * brt;
                float intensity = dot(brtColor, luminanceCoeff);

                float3 satColor = lerp(intensity, brtColor, sat);
                float3 conColor = lerp(avgLum, satColor, con);
                return conColor;
            }
            
            fixed4 frag (v2f_img i) : COLOR
            {
                float c = tex2D(_MainTex, i.uv);
                c.rgb = ContrastSaturationBrightness(c.rgb, BrightnessAmount, SaturationAmount, ContrastAmount);
                return c;
            }
            ENDCG
        }
    }
}
