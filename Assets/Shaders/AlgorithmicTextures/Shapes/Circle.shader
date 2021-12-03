Shader "Unlit/Circle"
{
    Properties
    {
        ColorA ("ColorA", Color) = (0, 0, 0, 1) 
        ColorB ("ColorB", Color) = (1, 1, 1, 1)
        Size ("Size", Range(0, 0.5)) = 0.2
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
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float dist = distance(i.uv - 0.5, float2(0, 0));
                
                float t = step(dist, Size);
          
                fixed4 col = lerp(ColorA, ColorB, t);
                return col;
            }
            ENDCG
        }
    }
}
