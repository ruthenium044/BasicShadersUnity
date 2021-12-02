Shader "Custom/AlbedoWorld"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        
        #pragma target 3.0

        struct Input
        {
            float3 worldRefl;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        
        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = IN.worldRefl;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
