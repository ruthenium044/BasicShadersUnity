Shader "Unlit/ReflectionWorld"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass
        {
            CGPROGRAM
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 worldReflection : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float3 worldReflection : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
                float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldReflection = reflect(-worldViewDir, worldNormal);
                o.normal = v.normal;
                return o;
            }

            fixed4 frag (v2f i) : COLOR
            {
                fixed4 col;
                half4 skyCube = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, i.worldReflection);
                half3 skyColor = DecodeHDR (skyCube, unity_SpecCube0_HDR);
                col.rgb = skyColor;
                return fixed4(col.rgb, 1);
            }
            ENDCG
        }
    }
}
