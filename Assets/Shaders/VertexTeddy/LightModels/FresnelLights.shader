Shader "Unlit/FresnelLights"
{
    Properties
    {   
        Gloss ("Gloss", Range(0, 1)) = 1
        SurfaceColor ("SurfaceColor", Color) = (1, 1, 1, 1)
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
            #include "AutoLight.cginc"
            #include "UnityLightingCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
            };

            float Gloss;
            float4 SurfaceColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                //diffuse
                float3 n = normalize(i.normal);
                float3 l = _WorldSpaceLightPos0.xyz;
                float3 lambert = saturate(dot(n, l));
                float3 diffuse = lambert * _LightColor0.xyz;
                
                //specular
                float3 v = normalize(_WorldSpaceCameraPos - i.worldPos);
                float3 h = normalize(l + v);
                const float3 specularExponent = exp2(Gloss * 6) + 2; //not great can be done in c#

                float3 specular = saturate(dot(h, n) * (lambert > 0));
                specular = pow(specular, specularExponent) * Gloss;
                specular *= _LightColor0.xyz;

                float fresnel = 1 - dot(v, n);
                return float4(diffuse * SurfaceColor + specular + fresnel, 1);
            }
            ENDCG
        }
    }
}
