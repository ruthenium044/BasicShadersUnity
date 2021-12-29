Shader "Unlit/ScrollingWave"
{
    Properties //input data
    {
        ColorA ("ColorA", Color) = (1, 1, 1, 1)
        
        Frequency ("Frequency", Float) = 1.0
        WaveAmplitude ("Wave Amplitude", Float) = 1.0
        
        MainTex ("MainTex", 2D) = "white" {}
        FoamTex ("FoamTex", 2D) = "white" {}
        Scroll ("Scroll", Float) = 1
       
    }
    SubShader
    {
        Lighting Off
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert vertex:vert nolightmap
        #include "UnityCG.cginc"
        
        float4 ColorA;
        
        float Frequency;
        float WaveAmplitude;

        sampler2D MainTex;
        sampler2D FoamTex;
        float Scroll;

        struct Input
        {
            float2 uvMainTex;
            float2 uvFoamTex;
            float3 vertColor;
        };

        struct appdata {
          float4 vertex: POSITION;
          float3 normal: NORMAL;
          float4 texcoord: TEXCOORD0;
        };
        
        float CosWave(float uv, float freqMod, float ampMod)
        {
            return cos((uv - _Time.y * 0.2) * 2 * UNITY_PI * Frequency * freqMod) * WaveAmplitude * ampMod;
        }

        void vert (inout appdata v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input,o);
            float wave = CosWave(v.texcoord.y, 1, 1) + CosWave(v.texcoord.y, 2, 2);
            float wave2 = CosWave(v.texcoord.x, 1, 1) + CosWave(v.texcoord.x, 2, 2);
                v.vertex.y = wave * wave2;
            v.normal = normalize(float3(v.normal.x + wave, v.normal.y, v.normal.z));
            o.vertColor =  v.vertex.y + 2;
        }
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            Scroll *= _Time.y;
            float3 water = tex2D(MainTex, IN.uvMainTex + float2(Scroll, Scroll)).rgb * 1.5;
            float3 foam = tex2D(FoamTex, IN.uvFoamTex + float2(Scroll / 2, Scroll / 2)).rgb;     
            o.Albedo.rgb = (water + foam) / 2 * ColorA * IN.vertColor; 
        }
        ENDCG
    }
}
