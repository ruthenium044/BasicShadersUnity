Shader "Custom/BasicToon"
{
    Properties
    {
        MainColor ("Color", Color) = (1,1,1,1)
        RampTexture ("RampTexture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf ToonRamp

        fixed4 MainColor;
        sampler2D RampTexture;

        half4 LightingToonRamp (SurfaceOutput o, half3 lightDir, fixed atten)
        {
            half diff = dot(o.Normal, lightDir);
            float h = diff * 0.5 + 0.5;
            float2 rh = -h;
            float3 ramp = tex2D(RampTexture, rh).rgb;
  
            half4 c;
            c.rgb = o.Albedo * _LightColor0.rgb * ramp;
            c.a = o.Alpha;
            return c;
        }
        
        struct Input
        {
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            float diff = dot (o.Normal, IN.viewDir);
			float h = diff * 0.5 + 0.5;
			float2 rh = h;
			o.Albedo = (1 - tex2D(RampTexture, rh).rgb) * MainColor;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
