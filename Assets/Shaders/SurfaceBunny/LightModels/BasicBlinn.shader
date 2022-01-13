Shader "Custom/BasicBlinn"
{
    Properties
    {
        MainColor ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf BasicBlinn

        half4 LightingBasicBlinn (SurfaceOutput o, half3 lightDir, half3 viewDir, half atten)
        {
            half3 h = normalize(lightDir + viewDir);
            half diff = max(0, dot(o.Normal, lightDir));
            float nh = max(0, dot(o.Normal, h));
            float spec = pow(nh, 48.0);
  
            half4 c;
            c.rgb = (o.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten;
            c.a = o.Alpha;
            return c;
        }
        
        struct Input
        {
            float2 uv_MainTex;
        };
        
        fixed4 MainColor;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = MainColor.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
