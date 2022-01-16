Shader "Unlit/Vortex"
{
    Properties
    {
        ColorA ("ColorA", Color) = (0, 0, 0, 1) 
        ColorB ("ColorB", Color) = (1, 1, 1, 1)
        Size ("Size", Range(0, 1)) = 0.2
        Roll ("Roll", Float) = 0.2
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
            half Size;
            half Roll;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv * 2 - 1;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float r =  length(i.uv) / Size;
                float a = atan2(i.uv.x, i.uv.y);
                
                float x = a + r * UNITY_TWO_PI * Roll;
                float t = frac(x * 2.23);
                
                t = step(r, t);
                fixed4 col = lerp(ColorA, ColorB, t);
                return col;
            }
            ENDCG
        }
    }
}
