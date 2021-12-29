Shader "Unlit/Ska"
{
    Properties
    {
        Density("Density", Range(2, 50)) = 30
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
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float Density;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv * Density;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 col = i.uv;
                col = floor(col) / 2;
                float checker = frac(col.x + col.y) * 2;
                return checker;
            }
            ENDCG
        }
    }
}
