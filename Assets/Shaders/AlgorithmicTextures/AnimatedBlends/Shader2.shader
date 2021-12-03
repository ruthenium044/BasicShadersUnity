Shader "Unlit/Shader2"
{
    Properties //input data
    {
        ColorA ("ColorA", Color) = (1, 1, 1, 1)
        ColorB ("ColorB", Color) = (1, 1, 1, 1)
        
        OffsetX ("OffsetX", Float) = 15.9
        Amplitude ("Amplitude", Int) = 1
        TimeScale ("TimeScale", Float) = 0.5
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
            int Amplitude;
            float TimeScale;

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex); //converts local to clip
                o.normal = UnityObjectToWorldNormal( v.normals );
                o.uv = v.uv;
                return o;
            }
            
            float Wave(float2 uv)
            {
                float WaveX = sin(uv.y * 2 * UNITY_PI + OffsetX) + _Time.y * TimeScale;
                float t = sin((uv.x + WaveX) * 2 * UNITY_PI * Amplitude) ;
                return t;
            }
            
            float4 frag (v2f i) : SV_Target
            {
                float t = Wave(i.uv);
                float4 outColor = lerp(ColorA, ColorB, t);
                return outColor;
            }
            
            ENDCG
        }
    }
}
