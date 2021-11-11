Shader "Unlit/Healthbar6"
{
    Properties
    {
        MainTex ("Texture", 2D) = "white" {}
        BgColor ("Color", Color) = (1, 1, 1, 1)
        
        [MaterialToggle] TransparentBackground ("TransparentBackground", Int) = 0
        Scaler ("Scaler", Float) = 1
        BorderSize ("BorderSize", Range(0,1)) = 1
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
            float Scaler;
            float BorderSize;
            
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
                //distance cuts a circle basically
                //float distance = length(i.uv) - 1;
                //distance = step(0, distance);
                float2 coords = i.uv;
                coords.x *= Scaler;

                float2 midleLine = float2(clamp(coords.x, 0.5, Scaler - 0.5), 0.5);
                float sdf = distance(coords, midleLine) * 2 - 1;
                clip(-sdf);

                float borderSdf = sdf + BorderSize;
                float borderMask = step(0, -borderSdf);
                
                float healthMask = HealthValue > i.uv.x;
                if (TransparentBackground)
                {
                    clip(healthMask - 0.5);
                }
                float2 newUV = float2(HealthValue, i.uv.y);
                float4 col = tex2D(MainTex, newUV);
                
                float4 outColor = lerp(BgColor, col, healthMask * borderMask);
                return outColor;
            }
            ENDCG
        }
    }
}
