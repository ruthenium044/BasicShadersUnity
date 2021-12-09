Shader "Custom/Explode"
{
    Properties
    {
        RampTex ("RampTex", 2D) = "white" {}
        RampOffset("RampOffset", Range(-0.5, 0.5)) = 0.5
        
        NoiseTex ("NoiseTex", 2D) = "gray" {}
        Period("Period", Range(0, 1)) = 0.5
        
        Amount ("Amount", Range(0,1)) = 0.5
        ClipRange ("ClipRange", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert vertex:vert nolightmap
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uvNoiseTex;
        };

        sampler2D RampTex;
        half RampOffset;

        sampler2D NoiseTex;
        float Period;

        half Amount;
        half ClipRange;

        void vert(inout appdata_full v)
        {
            float3 disp = tex2Dlod(NoiseTex, float4(v.texcoord.xy, 0,0 ));
            float time = sin(_Time[3] * Period + disp.r * 10);
            v.vertex.xyz += v.normal * disp.r * Amount * time;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            float3 noise = tex2D(NoiseTex, IN.uvNoiseTex);
            float n = saturate(noise.r + RampOffset);
            clip(ClipRange - n);

            half4 c = tex2D(RampTex, float2(n, 0.5));
            o.Albedo = c.rgb;
            o.Emission = c.rgb * c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
