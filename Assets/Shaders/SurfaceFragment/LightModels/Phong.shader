Shader "Unlit/Phong "
{
    Properties
    {   
        Gloss ("Gloss", Float) = 1
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

            float Gloss = 1;

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

                //specular
                float3 v = normalize(_WorldSpaceCameraPos - i.worldPos);
                float3 r = reflect(-l, n);
                float3 specular = saturate(dot(v, r));
                
                specular = pow(specular, Gloss);
                return float4(specular.xxx, 1);
            }
            ENDCG
        }
    }
}
