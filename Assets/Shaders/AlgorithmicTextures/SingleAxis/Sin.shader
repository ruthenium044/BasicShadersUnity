Shader "Unlit/Sin"
{
    Properties {
        ColorA ("ColorA", Color) = (0, 0, 0, 1) 
        ColorB ("ColorB", Color) = (1, 1, 1, 1)
        
        Frequency ("Frequency", Float) = 1
        Displacement ("Displacement", Float) = 1
        Amplitude ("Amplitude", Float) = 1
        Speed ("Speed", Float) = 1
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
 
            float Frequency;
            float Displacement;
            float Amplitude;
            float Speed;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float t = sin(i.uv.x * UNITY_PI * Frequency + _Time.y * Speed) * Amplitude + Displacement;
                fixed4 col = lerp(ColorA, ColorB, t);
                return col;
            }
            ENDCG
        }
    }
}
