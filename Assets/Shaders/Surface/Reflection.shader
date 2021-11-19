Shader "Unlit/ReflectionNormal"
{
    Properties
    {
        Texture ("Texture", 2D) = "white" {}
        OcclusionMap("Occlusion", 2D) = "white" {}
        NormalMap ("NormalMap", 2D) = "bump" {}
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
                float3 worldPos : TEXCOORD0;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD4;
                float4 tangent : TANGENT;
            };

            struct v2f
            {
                float3 worldPos : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                half3 tangentSpace0 : TEXCOORD1; 
                half3 tangentSpace1 : TEXCOORD2; 
                half3 tangentSpace2 : TEXCOORD3;
                float2 uv : TEXCOORD4;
                float4 tangent : TANGENT;
            };

            sampler2D Texture;
            sampler2D OcclusionMap;
            sampler2D NormalMap;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = v.normal;
                o.tangent = v.tangent;
                o.uv = v.uv;
                
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                half3 wNormal = UnityObjectToWorldNormal(v.normal);
                half3 wTangent = UnityObjectToWorldDir(wNormal);
                
                half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
                half3 wBitangent = cross(wNormal, wTangent) * tangentSign;
                
                o.tangentSpace0 = half3(wTangent.x, wBitangent.x, wNormal.x);
                o.tangentSpace1 = half3(wTangent.y, wBitangent.y, wNormal.y);
                o.tangentSpace2 = half3(wTangent.z, wBitangent.z, wNormal.z);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half3 normalTexture = UnpackNormal(tex2D(NormalMap, i.uv));
                half3 worldNormal = {
                    dot(i.tangentSpace0, normalTexture),
                    dot(i.tangentSpace1, normalTexture),
                    dot(i.tangentSpace2, normalTexture)};
                half3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                half3 worldReflection = reflect(-worldViewDir, worldNormal);
                
                half4 skyCube = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, worldReflection);
                half3 skyColor = DecodeHDR (skyCube, unity_SpecCube0_HDR);
                fixed4 col;
                col.rgb = skyColor;

                //adding texture to the mess above
                fixed3 textureColor = tex2D(Texture, i.uv).rgb;
                fixed occlusion = tex2D(OcclusionMap, i.uv).r;
                col.rgb *= textureColor;
                col.rgb *= occlusion;
                return fixed4(col.rgb, 1);
            }
            ENDCG
        }
    }
}
