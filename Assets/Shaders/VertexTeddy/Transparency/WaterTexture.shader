Shader "Unlit/WaterTexture"
{
    Properties
    {
        [Header(Visuals)] 
        MainColor ("Tint", Color) = (1, 1, 1, 1)
        MainTex ("Water texture", 2D) = "white" {}
        FoamTex ("Foam texture", 2D) = "white" {}
        
        [Header(Texture scrolling)]
        [ShowAsVector2] Scroll ("Water scroll", Vector) = (0, 0, 0, 0)
        [ShowAsVector2] ScrollOffset ("Foam scroll", Vector) = (0, 0, 0, 0)
        Intensity ("Water intensity", Range(0, 1)) = 0.25
        
        [Header(Distortion)]
        NoiseTex ("Distortion texture", 2D) = "white" {}
        Period ("Period", Range(0, 50)) = 0.05
        Magnitude ("Magnitude", Range(0, 0.5)) = 0.05
        Scale ("Scale", Range(0, 10)) = 1
        
        [Header(Vertex Wave)]
        Frequency ("Frequency", Range(0, 4)) = 0.2
        Amplitude ("Amplitude", Range(0, 0.5)) = 0.2
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent" "IgnoreProjector" = "True" }
        
        GrabPass{}
        
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
                float3 normal: NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
                float2 uv : TEXCOORD0;
                float4 worldPos : TEXCOORD1;
                float4 uvgrab : TEXCOORD2;
                float3 normal: NORMAL;
            };

            fixed4 MainColor;
            sampler2D MainTex;
            sampler2D FoamTex;
            
            float2 Scroll;
            float2 ScrollOffset;
            float Intensity;
            
            sampler2D NoiseTex;
            sampler2D _GrabTexture;
            float Period; 
            float Magnitude;
            float Scale;
            
            float Frequency;
            float Amplitude;

            float GetWave(float uv)
            {
                return cos((uv - _Time.y * 0.2) * 2 * UNITY_PI * Frequency) * Amplitude;
            }
            
            v2f vert (appdata v)
            {
                v2f o;
                float wave = GetWave(v.uv.y) + GetWave(v.uv.y);
                float wave2 = GetWave(v.uv.x) + GetWave(v.uv.x);
                v.vertex.y = wave * wave2;
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                o.uv = v.uv;
                o.uvgrab = ComputeGrabScreenPos(o.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                v.normal = normalize(float3(v.normal.x, v.normal.y, v.normal.z));
                return o;
            }

            fixed4 frag (v2f i) : COLOR
            {
                float sinT = sin(_Time.w / Period);
                float2 distortion = float2(tex2D(NoiseTex, i.worldPos.xy / Scale + float2(sinT, 0)).r - 0.5,
                                           tex2D(NoiseTex, i.worldPos.xy / Scale + float2(0, sinT)).r - 0.5);
                i.uvgrab.xy += distortion * Magnitude;
                fixed4 transparentWater = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
                
                Scroll *= _Time.y;
                ScrollOffset *= _Time.y;
                float4 water = tex2D(MainTex, i.uv + Scroll) * Intensity;
                float4 foam = tex2D(FoamTex, i.uv + ScrollOffset); 
                fixed4 waterTexture = water + foam;
                
                return transparentWater * MainColor * waterTexture;
            }
            ENDCG
        }
    }
}
