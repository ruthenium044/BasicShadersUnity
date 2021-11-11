Shader "Unlit/Healthbar3"
{
    Properties
    {
        Color1 ("Color1", Color) = (1, 1, 1, 1)
        Color2 ("Color2", Color) = (1, 1, 1, 1)
        Transparency ("Transparency", Range(0, 1)) = 0
        HealthValue ("HealthValue", Range(0,1)) = 1
        MaxHealth ("MaxHealth", Range(0,1)) = 0
        MinHealth ("MinHealth", Range(0,1)) = 1
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" 
                "Queue" = "Transparent" }
        LOD 100

        Pass
        {
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            
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
            float Transparency;
            float HealthValue;
            float MaxHealth;
            float MinHealth;

            v2f vert (appdata v)
            {
                v2f o; 
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal( v.normals );
                o.uv = v.uv;
                return o;
            }

            float InverseLerp(float a, float b, float t)
            {
                return (t - a)/ (b - a);
            }

            float4 frag (v2f i) : SV_Target
            {
                float t = saturate(InverseLerp(MinHealth, MaxHealth, HealthValue));
                float3 lerpedColor = lerp(Color1, Color2, t);
                
                float healthMask = HealthValue > i.uv.x;
                return float4(lerpedColor, healthMask * Transparency);
            }
            ENDCG
        }
    }
}
