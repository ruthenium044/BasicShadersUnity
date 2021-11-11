Shader "Unlit/Shader5"
{
    Properties //input data
    {
        ColorA ("ColorA", Color) = (1, 1, 1, 1)
        ColorB ("ColorB", Color) = (1, 1, 1, 1)
        
        ValueX ("ValueX", Float) = 1.0
        ValueY ("ValueY", Float) = 1.0
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
            
            float OffsetX;
            float ValueY;
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

            float InverseLerp(float a, float b, float t)
            {
                return (t - a)/ (b - a);
            }
            
            float Wave(float2 uv)
            {
                float2 uvCentered = uv * 2 - 1;
                float radius = length(uvCentered);
                
                float wave = cos((radius - _Time.y * 0.2) * 2 * UNITY_PI * ValueY);
                wave *= 1 - radius;
                return wave;
            }

            v2f vert (appdata v)
            {
                v2f o;
                v.vertex.y = Wave(v.uv) * WaveAmplitude;    
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal( v.normals );
                o.uv = v.uv;
                return o;
            }
            
            float4 frag (v2f i) : SV_Target
            {
                return Wave(i.uv);
            }
            
            ENDCG
        }
    }
}
