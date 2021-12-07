Shader "Lit/RecieveShadows"
{
    Properties
    {
        [NoScaleOffset] MainTexture ("MainTexture", 2D) = "white" {}
        ShadowColor ("ShadowColor", Color) = (1,1,1,1)
        }
    SubShader
    {
        Pass
        {
            Tags {"LightMode"="ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            
            #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
            #include "AutoLight.cginc"

            struct v2f
            {
                float2 uv : TEXCOORD0;
                SHADOW_COORDS(1)
                fixed3 diff : COLOR0;
                fixed3 ambient : COLOR1;
                float4 pos : SV_POSITION;
            };
            
            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                o.diff = nl * _LightColor0.rgb;
                o.ambient = ShadeSH9(half4(worldNormal,1));
                TRANSFER_SHADOW(o)
                return o;
            }

            sampler2D MainTexture;
            fixed4 ShadowColor;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(MainTexture, i.uv);
                fixed shadow = SHADOW_ATTENUATION(i);
                fixed3 lighting = i.diff * shadow + i.ambient + (shadow < 0.2 ? ShadowColor:0);
                col.rgb *= lighting;
                return col;
            }
            ENDCG
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}