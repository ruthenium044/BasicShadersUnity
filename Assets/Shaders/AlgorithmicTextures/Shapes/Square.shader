Shader "Unlit/Square"
{
    Properties
    {
        ColorA ("ColorA", Color) = (0, 0, 0, 1) 
        ColorB ("ColorB", Color) = (1, 1, 1, 1)
        Size ("Size", Range(0, 1)) = 1
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
                float top = smoothstep(Size, i.uv.y, 1);
                float right = step(Size, i.uv.x);

                float bottom = step(Size, 1 - i.uv.y);
                float left = step(Size, 1 - i.uv.x);
                
                float t = top * right * bottom * left;
          
                fixed4 col = lerp(ColorA, ColorB, t);
                return col;
            }
            ENDCG
        }
    }
}
