// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/Wireframe"
{
    Properties
    {
        EdgeColor ("Edge Color", Color) = (0,1,0,1)
        Width ("Width", Range(0, 1)) = 0.1
        TilingFactor ("TilingFactor", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Front
            AlphaTest Greater 0.5
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            float4 EdgeColor;
            float Width;
            float TilingFactor;
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };
            
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            
            fixed4 frag (v2f i) : COLOR
            {
                float2 tiledUV = frac(i.uv * TilingFactor);
                float thing = step(Width, max(tiledUV.x,tiledUV.y));
                
                float4 col;
                col = thing * EdgeColor;
                return col;
            }
            ENDCG
        }
        
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Back
            AlphaTest Greater 0.5
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            float4 EdgeColor;
            float Width;
            float TilingFactor;
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };
            
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            
            fixed4 frag (v2f i) : COLOR
            {
                float2 tiledUV = frac(i.uv * TilingFactor);
                float thing = step(Width, max(tiledUV.x, tiledUV.y));
                
                float4 col;
                col = thing * EdgeColor;
                return col;
            }
            ENDCG
        }

    }
}




               
