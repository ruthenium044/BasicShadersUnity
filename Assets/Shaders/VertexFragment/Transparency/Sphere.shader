Shader "Unlit/Sphere"
{
    Properties
    { 
        MainColor ("MainColor", Color) = (1, 1, 1, 1)
        Step ("Steps", Float) = 64
        StepSize ("StepSize", Float) = 0.01
        Radius ("Radius", Range(0.0001, 1)) = 0.5
        SpaceOffset ("Offset", Vector) = (0, 0, 0, 0)
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //#include "UnityLightingCommon.cginc"

            fixed4 MainColor;
            float Step;
            float StepSize;
            float Radius;
            float3 SpaceOffset;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float3 wPos : TEXCOORD0;
                float4 pos : SV_POSITION;
                float3 origin : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.origin = UNITY_MATRIX_M._m03_m13_m23;
                return o;
            }

            bool SphereHit(float3 pos, float3 center, float radius)
            {
                return distance(pos, center) < radius;
            }

            float3 RaymarchHit(float3 pos, float3 direction, float3 center)
            {
                for (int i = 0; i < Step; i++)
                {
                    if (SphereHit(pos, center, Radius))
                    {
                        return pos;
                    }
                    pos += direction * StepSize;
                }
                return float3(0, 0, 0);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 viewDir = normalize(i.wPos - _WorldSpaceCameraPos);
                float3 worldPos = i.wPos;
                float3 center = i.origin + SpaceOffset;
                float3 depth = RaymarchHit(worldPos, viewDir, center);
                //half3 worldNormal = depth - center;
                //half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
         
                if (length(depth) != 0)
                {
                    //depth *= nl * _LightColor0;
                    return MainColor;
                }
                return fixed4(1, 1, 1, 0);
            }
            ENDCG
        }
    }
}
