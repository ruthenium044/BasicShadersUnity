Shader "Unlit/Skybox"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
                float3 viewDirection : TEXCOORD0;
            };

            struct v2f
            {
                float3 viewDirection : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float2 DirectionToRect(float3 dir)
            {
                float x = atan2(dir.z, dir.x) / 2 * UNITY_PI + 0.5f;
                float y = dir.y * 0.5f + 0.5f;
                return float2(x, y);
            }
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.viewDirection = v.viewDirection;
                return o;
            }

            float3 frag (v2f i) : SV_Target
            {
                // sample the texture
                float3 col = tex2Dlod(_MainTex, float4(DirectionToRect(i.viewDirection), 0, 0));
                return col;
            }
            ENDCG
        }
    }
}
