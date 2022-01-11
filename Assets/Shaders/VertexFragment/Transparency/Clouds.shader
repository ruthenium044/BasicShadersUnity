Shader "Unlit/Clouds"
{
    Properties
    {
        Scale ("Scale", Range(0.1, 10)) = 2
        StepScale ("StepScale", Range(0.1, 100)) = 1
        Steps ("Steps", Range(1, 200)) = 60
        MinHeight ("MinHeight", Range(0, 5)) = 0
        MaxHeight ("MaxHeight", Range(6, 10)) = 0
        FadeDist ("FadeDist", Range(0, 5)) = 0
        SunDIr ("SunDir", Vector) = (1, 0, 0, 0)
        //_MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off Lighting Off ZWrite Off
        ZTest Always

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
                float4 pos : SV_POSITION;
                float3 view : TEXCOORD1;
                float3 origin : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
