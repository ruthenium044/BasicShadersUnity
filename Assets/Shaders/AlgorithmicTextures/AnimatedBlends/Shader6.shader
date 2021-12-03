Shader "Unlit/Shader6"
{
    Properties //input data
    {
        MainTex ("Texture", 2D) = "white" {}
        MainTex2 ("Texture2", 2D) = "white" {}
        PatternTex ("Pattern", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D MainTex;
            float4 MainTex_ST;
            sampler2D MainTex2;
            sampler2D PatternTex;

            struct appdata //mesh data per vertex
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f //vertex 2 fragment
            {
                float4 vertex : SV_POSITION; //clip space position
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };
            
            v2f vert (appdata v)
            {
                v2f o;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            
            float4 frag (v2f i) : SV_Target
            {
                float2 projection = i.worldPos.xz;
                float4 tex = tex2D(MainTex, projection);
                float4 tex2 = tex2D(MainTex2, projection);
                float pattern = tex2D(PatternTex, i.uv).x;
                float4 output = lerp( tex2, tex, pattern);
                return output;
            }
            ENDCG
        }
    }
}
