Shader "Custom/Snow"
{
    Properties
    {
        MainColor ("Color", Color) = (1,1,1,1)
        MainTex ("Albedo (RGB)", 2D) = "white" {}
        BumpTex ("BumpTex", 2D) = "bump" {}
        Snow ("LevelOfSnow", Range(1, -1)) = 1
        SnowColor ("SnowColor", Color) = (1,1,1,1)
        SnowDirection ("SnowDirection", Vector) = (0,1,0)
        SnowDepth ("SnowDepth", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard vertex:vert
        #pragma target 3.0

        sampler2D MainTex;
        sampler2D BumpTex;
        float4 MainColor;
        float4 SnowColor;
        float4 SnowDirection;
        float Snow;
        float SnowDepth;

        struct Input
        {
            float2 uvMainTex;
            float2 uvBumpTex;
            float3 worldNormal;
            INTERNAL_DATA
        };

        void vert(inout appdata_full v)
        {
            float4 snow = mul(UNITY_MATRIX_IT_MV, SnowDirection);
            if (dot(v.normal, snow.xyz) >= Snow)
            {
                v.vertex.xyz += (snow.xyz + v.normal) * SnowDepth * Snow;
            }
        }
        
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            half4 c = tex2D (MainTex, IN.uvMainTex);
            o.Normal = UnpackNormal(tex2D(BumpTex, IN.uvBumpTex));

            if (dot(WorldNormalVector(IN, o.Normal), SnowDirection.xyz) >= Snow)
            {
                o.Albedo = SnowColor.rgb;
            }
            else
            {
                o.Albedo = c.rgb * MainColor;
            }
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
