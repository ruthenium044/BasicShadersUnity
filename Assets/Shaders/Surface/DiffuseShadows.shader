Shader "Unlit/DiffuseShadows"
{
    Properties
    {
        MainTexture ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
            Tags {"LightMode"="ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                fixed3 diffuse : COLOR0;
                fixed3 ambient : COLOR1;
                float2 uv : TEXCOORD0;
                SHADOW_COORDS(1)
            };

            sampler2D MainTexture;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half lambert = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                o.diffuse = lambert * _LightColor0.xyz;
                o.ambient = ShadeSH9(half4(worldNormal, 1));
                TRANSFER_SHADOW(o)
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(MainTexture, i.uv);
                fixed shadow = SHADOW_ATTENUATION(i);
                fixed3 lights = i.diffuse * shadow + i.ambient;
                col.rgb *= lights;
                return fixed4(col.rgb, 1);
            }
            ENDCG
        }
    }
}
