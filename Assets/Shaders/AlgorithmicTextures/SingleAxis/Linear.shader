Shader "Unlit/Linear"
{
    Properties {
        ColorA ("ColorA", Color) = (1, 1, 1, 1)
        ColorB ("ColorB", Color) = (0, 0, 0, 1)
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
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float4 ColorA;
            float4 ColorB;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float t = i.uv.x;
                //t = modf(t,0.5); // return x modulo of 0.5
                //t = frac(t); // return only the fraction part of a number
                //t = ceil(t);  // nearest integer that is greater than or equal to x
                //t = floor(t); // nearest integer less than or equal to x
                //t = sign(t);  // extract the sign of x
                //t = abs(t);   // return the absolute value of x
                //t = clamp(t,0.0,1.0); // constrain x to lie between 0.0 and 1.0
                //t = min(0.0,t);   // return the lesser of x and 0.0
                //t = max(0.0,t);   // return the greater of x and 0.0 
                fixed4 col = lerp(ColorA, ColorB, t);
                return col;
            }
            ENDCG
        }
    }
}
