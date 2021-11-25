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
            
            fixed4 frag (v2f i) : SV_Target
            {
                float x = i.uv.x;
                float y = InBounce(x);
                
                fixed4 col = lerp(ColorA, ColorB, y);
                return col;
            }
            ENDCG
        }
    }
}
