Shader "Unlit/WaveMultiple"
{
    Properties //input data
    {
        ColorA ("ColorA", Color) = (1, 1, 1, 1)
        ColorB ("ColorB", Color) = (1, 1, 1, 1)
        
        Frequency ("Frequency", Float) = 1.0
        WaveAmplitude ("Wave Amplitude", Float) = 1.0
       
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 ColorA;
            float4 ColorB;
            
            float Frequency;
            float WaveAmplitude;

            struct appdata //mesh data per vertex
            {
                float4 vertex : POSITION;
                float3 normals : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f //vertex 2 fragment
            {
                float4 vertex : SV_POSITION; //clip space position
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            float CosWave(float uv)
            {
                return cos((uv - _Time.y * 0.2) * 2 * UNITY_PI * Frequency) * WaveAmplitude;
            }

            v2f vert (appdata v)
            {
                v2f o;
                float wave = CosWave(v.uv.y) * CosWave(v.uv.x);
                v.vertex.y = wave;
                
                o.vertex = UnityObjectToClipPos(v.vertex); //converts local to clip
                o.normal = UnityObjectToWorldNormal( v.normals );
                o.uv = v.uv; //v.uv * _Scale + _Offset;
                return o;
            }
            
            float4 frag (v2f i) : SV_Target
            {
                float wave = CosWave(i.uv.y) * CosWave(i.uv.x);
                fixed4 t = wave * 2;
                t = lerp(ColorA, ColorB, t);
                return t;
            }
            
            ENDCG
        }
    }
}
