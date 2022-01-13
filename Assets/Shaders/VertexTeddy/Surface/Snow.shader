Shader "Unlit/Snow"
{
    Properties
    {
        MainTex ("Texture", 2D) = "white" {}
        MainColor ("Color", Color) = (0, 0, 0, 0)
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
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD1;
            };

            sampler2D MainTex;
            float4 MainTex_ST;
            fixed4 MainColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            float InvLerp( float a, float b, float v ){
                return (v-a)/(b-a);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(MainTex, i.uv);
                float t = InvLerp( 0.01, 0.7, i.normal.y );
                t = saturate(t);
                fixed4 outCol = lerp(col, MainColor, t);
                return  outCol;
            }
            ENDCG
        }
    }
}
