Shader "Unlit/Normal"
{
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
                half3 worldNormal : TEXCOORD0;
            };

            struct v2f
            {
                half3 worldNormal : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.worldNormal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col;
                col.rgb = i.worldNormal * 0.5f + 0.5f;
                return fixed4(col.rgb, 1);
            }
            ENDCG
        }
    }
}
