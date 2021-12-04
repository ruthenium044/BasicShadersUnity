Shader "Unlit/Mix"
{
    Properties
    {
        ColorA ("ColorA", Color) = (0, 0, 0, 1) 
        ColorB ("ColorB", Color) = (1, 1, 1, 1)
        Size ("Size", Int) = 3
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

            float4 ColorA;
            float4 ColorB;
            int Size;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv * 2 - 1;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float r = UNITY_TWO_PI / float(Size);
                float a = atan2(i.uv.x , i.uv.y) + UNITY_PI;
                float t = cos(floor(0.5f + a / r) * r - a) * length(i.uv);
                float t2 = abs(cos(a * 2.5)) * 0.5 + 0.6;
                
                float3 col = 1 - smoothstep(0.4, 0.4, t * t2);
                col = lerp(ColorA, ColorB, col);
                
                return fixed4(col, 1);
            }
            ENDCG
        }
    }
}
