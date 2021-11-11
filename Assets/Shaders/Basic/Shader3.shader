Shader "Unlit/Shader3"
{
    Properties //input data
    {
        ColorA ("ColorA", Color) = (1, 1, 1, 1)
        ColorB ("ColorB", Color) = (1, 1, 1, 1)
        
        ValueX ("OffsetX", Float) = 1.0
        ValueY ("ValueY", Float) = 1.0
       
    }
    SubShader
    {
        Tags { "RenderType"="Transperent" 
            "Queue"="Transparent"}

        Pass
        {
            Cull Off
            ZWrite Off
            ZTest LEqual
            
            Blend One One // additive
            //Blend DstColor Zero //multiply
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 ColorA;
            float4 ColorB;
            
            float OffsetX;
            float ValueY;

            struct appdata //mesh data per vertex
            {
                float4 vertex : POSITION;
                float3 normals : NORMAL;
                //float4 tangent : TANGENT;
                //float4 color : COLOR;
                float2 uv : TEXCOORD0;
            };

            struct v2f //vertex 2 fragment
            {
                float4 vertex : SV_POSITION; //clip space position
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex); //converts local to clip
                o.normal = UnityObjectToWorldNormal( v.normals );
                //mul(v.normals, (float3x3)unity_WorldToObject);
                o.uv = v.uv; //v.uv * _Scale + _Offset;
                return o;
            }

             float InverseLerp(float a, float b, float t)
            {
                return (t - a)/ (b - a);
            }
            
            float4 frag (v2f i) : SV_Target
            {
                float OffsetX = cos(i.uv.x * ValueY) ;
                float t = cos((i.uv.y + OffsetX - _Time.y) * ValueY);
                t *= 1 - i.uv.y;
                //remove the tops of cilinder
                float removeBottom = (abs(i.normal.y) < 0.999);
                float wave = t * removeBottom;
                
                float4 gradient = lerp(ColorA, ColorB, t);
                return gradient * wave;
            }
            
            ENDCG
        }
    }
}
