Shader "Custom/Advanced"
{
    Properties
    {
        MainTexture ("MainTexture", 2D) = "white" {}
        OutlineColor ("OutlineColor", Color) = (1,1,1,1)
        OutlineWidth ("OutlineWidth", Range(0.02, 0.5)) = 0.05
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        
        CGPROGRAM
        #pragma surface surf Lambert 
        #pragma target 3.0

        struct Input
        {
            float2 uvMainTexture;
        };
        
        sampler2D MainTexture;
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(MainTexture, IN.uvMainTexture).rgb;
        }
        ENDCG
        
        Pass
        {
            Cull Front
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 normal : NORMAL;
            };

            struct v2f
            {
                float4 color : COLOR;
                float4 pos : SV_POSITION;
            };

            float4 OutlineColor;
            float OutlineWidth;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                
                float3 norm = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));
                float2 offset = TransformViewToProjection(norm.xy);
                
                o.pos.xy += offset * o.pos.z * OutlineWidth;
                o.color = OutlineColor;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return i.color;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
