Shader "Unlit/SkyboxLatlong"
{
    Properties
    {
        SkyboxTexture ("SkyboxTexture", 2D) = "white" {}
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
                float4 vertex : SV_POSITION;
                float2 viewDirection : TEXCOORD0;
            };

            sampler2D SkyboxTexture;

            float2 DirectionToRect(float3 dir)
            {
                dir = normalize(dir);
                //todo fix up the x value with this latrer
                //https://forum.unity.com/threads/equirectangular-background-shader.364287/
                float x = (atan2(dir.x, dir.z) + UNITY_PI) / UNITY_PI * 0.5f;
                float y = acos(-dir.y) / UNITY_PI;
                return float2(x, y);
            }
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.viewDirection = DirectionToRect(v.viewDirection);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float4 col = tex2D(SkyboxTexture, i.viewDirection);
                return col;
            }
            ENDCG
        }
    }
}
