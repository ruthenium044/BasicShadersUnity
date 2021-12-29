Shader "Unlit/ColorBlend"
{
    Properties //input data
    {
        ColorA ("ColorA", Color) = (1, 1, 1, 1)
        ColorB ("ColorB", Color) = (1, 1, 1, 1)
        ColorStart ("Color Start", Range(0, 1)) = 0
        ColorEnd ("Color End", Range(0, 1)) = 1
        
        Value ("Value", Float) = 1.0
        UVScale ("UV Scale", float) = 1.0
        UVOffset ("UV Offset", float) = 0.0
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
            float ColorStart;
            float ColorEnd;
            
            float Value;
            float Scale;
            float Offset;

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
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal( v.normals ) *  Value;
                //mul(v.normals, (float3x3)unity_WorldToObject);
                o.uv = v.uv;
                return o;
            }

            float InverseLerp(float a, float b, float t)
            {
                return (t - a)/ (b - a);
            }
            

            float4 frag (v2f i) : SV_Target
            {
                //float t = saturate(InverseLerp(ColorStart, ColorEnd, i.uv.x));
                float t = smoothstep(ColorStart, ColorEnd, i.uv.x);
                //t = frac(t);
                float4 outColor = lerp(ColorA, ColorB, t);
                return outColor;
            }

           
            ENDCG
        }
    }
}
