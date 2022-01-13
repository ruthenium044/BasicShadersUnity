Shader "Custom/Plasma"
{
    Properties
    {
        Tint ("Color", Color) = (1,1,1,1)
        Speed ("Speed", Range(0,100)) = 10
        Scale1 ("Scale1", Range(0.1, 10)) = 2
        Scale2 ("Scale2", Range(0.1, 10)) = 2
        Scale3 ("Scale3", Range(0.1, 10)) = 2
        Scale4 ("Scale4", Range(0.1, 10)) = 2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert
        #pragma target 3.0
        
        fixed4 Tint;
        float Scale1;
        float Scale2;
        float Scale3;
        float Scale4;
        float Speed;
        
        struct Input
        {
            float3 worldPos;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            float t =_Time.y * Speed;
            float c = sin(IN.worldPos.x * Scale1 + t);
            c += sin(IN.worldPos.z * Scale2 + t);
            c += sin(Scale3 * (IN.worldPos.x * sin(t / 2) + IN.worldPos.z * cos(t / 3)) + t);

            float c1 = pow(IN.worldPos.x + 0.5 * sin(t / 5), 2);
            float c2 = pow(IN.worldPos.z + 0.5 * cos(t / 3), 2);
            c += sin(sqrt(Scale4 * (c1 + c2) + 1 + t));
            
            o.Albedo.r = sin(c / 4 * UNITY_PI);
            o.Albedo.g = sin(c / 4 * UNITY_PI + 4 * UNITY_PI / 4);
            o.Albedo.b = sin(c / 4 * UNITY_PI + 2 * UNITY_PI / 4);
            o.Albedo *= Tint; 
        }
        ENDCG
    }
    FallBack "Diffuse"
}
