Shader "Lit/Diffuse"
{
    Properties
    {
        MainTexture ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "LightMode"="ForwardBase" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                fixed4 diffuse : COLOR0;
            };

            sampler2D MainTexture;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half lambert = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                o.diffuse = lambert * _LightColor0;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(MainTexture, i.uv);
                col *= i.diffuse;
                return col;
            }
            ENDCG
        }
    }
}
