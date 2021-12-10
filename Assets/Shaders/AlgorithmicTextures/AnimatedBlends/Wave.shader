Shader "Unlit/Wave"
{
    Properties
    {
        ColorA ("ColorA", Color) = (1, 1, 1, 1)
        ColorB ("ColorB", Color) = (1, 1, 1, 1)
        
        Frequency ("Frequency", Float) = 1.0
        WaveAmplitude ("Wave Amplitude", Float) = 1.0
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
            
            float4 ColorA;
            float4 ColorB;
            
            float Frequency;
            float WaveAmplitude;

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
            
            float CosWave(float uv)
            {
                return cos((uv - _Time.y * 0.2) * 2 * UNITY_PI * Frequency) * WaveAmplitude;
            }

            v2f vert (appdata v)
            {
                v2f o;
                float wave = CosWave(v.uv.y);
                v.vertex.y = wave;
                
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float wave = CosWave(i.uv.y);
                fixed4 t = wave;
                t = lerp(ColorA, ColorB, t);
                return t;
            }
            ENDCG
        }
    }
}
