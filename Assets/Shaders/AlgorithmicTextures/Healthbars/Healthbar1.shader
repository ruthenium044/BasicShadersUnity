Shader "Unlit/Healthbar1"
{
    Properties
    {
        Color1 ("Color1", Color) = (1, 1, 1, 1)
        Color2 ("Color2", Color) = (1, 1, 1, 1)
        Color3 ("Color3", Color) = (1, 1, 1, 1)
        BlurSize ("BlurSize", Range(0,1)) = 0
        Value ("Value", Range(0,1)) = 1
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
                float3 normals : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
            };

            float4 Color1;
            float4 Color2;
            float4 Color3;
            float BlurSize;
            float Value;

            v2f vert (appdata v)
            {
                v2f o; 
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal( v.normals );
                o.uv = v.uv;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float t = smoothstep(Value - BlurSize, Value + BlurSize, i.uv.x);
                float4 lerpedColor = lerp(Color1, Color2, Value);
                
                float4 outColor = lerp(lerpedColor, Color3, t);
                return outColor;
            }
            ENDCG
        }
    }
}
