Shader "Unlit/Bouncee"
{
    Properties {
        ColorA ("ColorA", Color) = (0, 0, 0, 1) 
        ColorB ("ColorB", Color) = (1, 1, 1, 1)
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
            #include "Assets/Shaders/Bouncee.cginc"

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

            float4 ColorA;
            float4 ColorB;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float2 toPolar(float2 cartesian)
            {
	            float distance = length(cartesian);
	            float angle = atan2(cartesian.y, cartesian.x);
	            return float2(angle / UNITY_TWO_PI, distance);
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = (i.uv - 0.5) * 2;
                float y = i.uv.y; //InBounce(x);

                float radius = length(uv);
                float angle = atan2(uv.y, uv.x);
                uv = float2(angle / UNITY_TWO_PI, radius);
                
                fixed2 col = lerp(ColorA, ColorB, uv.y);
                return fixed4(col, 0, 1);
            }
            ENDCG
        }
    }
}
