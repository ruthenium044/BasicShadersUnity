Shader "Unlit/Healthbar4"
{
    Properties
    {
        MainTex ("Texture", 2D) = "white" {}
        BgColor ("Color", Color) = (1, 1, 1, 1)
        [MaterialToggle] TransparentBackground ("TransparentBackground", Int) = 0
        FlashStrength ("FlashStrength", Range(0,1)) = 1
        FlashAmplitude ("FlashAmplitude", Float) = 1
        
        MinHealth ("MinHealth", Range(0,1)) = 1
        HealthValue ("HealthValue", Range(0,1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

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

            sampler2D MainTex;
            float4 MainTex_ST;
            float4 BgColor;
            float TransparentBackground;
            float FlashStrength;
            float FlashAmplitude;

            float MinHealth;
            float HealthValue;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float healthMask = HealthValue > i.uv.x;
                if (TransparentBackground)
                {
                    clip(healthMask - 0.5);
                }
                float2 newUV = float2(HealthValue, i.uv.y);
                float4 col = tex2D(MainTex, newUV);

                if (HealthValue < MinHealth)
                {
                    float flash = cos(_Time.y * FlashAmplitude) * FlashStrength + 1;
                    col *= flash;
                }
                
                float4 outColor = lerp(BgColor, col, healthMask);
                return outColor;
            }
            ENDCG
        }
    }
}
