Shader "Unlit/DistanceFields"
{
    Properties
    {
        ColorA ("ColorA", Color) = (0, 0, 0, 1) 
        ColorB ("ColorB", Color) = (1, 1, 1, 1)
        Size ("Size", Range(0, 0.5)) = 0.2
        Distance ("Distance", Range(0, 1)) = 0.3
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
            half Distance;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv * 2 - 1;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float sdf = length(abs(i.uv) - Distance);
                sdf = frac(sdf * 5);
                
                float t = step(sdf, Size);
                fixed3 col = lerp(ColorA, ColorB, t);
                return fixed4(col, 1);
            }
            ENDCG
        }
    }
}
