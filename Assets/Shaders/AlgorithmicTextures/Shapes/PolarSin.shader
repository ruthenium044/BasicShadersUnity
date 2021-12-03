Shader "Unlit/PolarSin"
{
    Properties
    {
        ColorA ("ColorA", Color) = (0, 0, 0, 1) 
        ColorB ("ColorB", Color) = (1, 1, 1, 1)
        Size ("Size", Range(0, 0.5)) = 0.2
        Distance ("Distance", Range(0, 1)) = 0.3
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
            half Size;
            half Distance;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv * 2 - 1;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float r = length(i.uv);
                float a = atan2(i.uv.y , i.uv.x);

                //can input bunch of stuff here for shapes
                float t = smoothstep(-0.5, 1, cos(a * 10)) * 0.2 + 0.5;

                //y = cos(x*3.);
                //y = abs(cos(x*3.));
                //y = abs(cos(x*2.5))*0.5+0.3;
                //y = abs(cos(x*12.)*sin(x*3.))*.8+.1;
                //y = smoothstep(-.5,1., cos(x*10.))*0.2+0.5;
                
                float3 col = 1 - smoothstep(t, t, r);
                col = lerp(ColorA, ColorB, col);
                return fixed4(col, 1);
            }
            ENDCG
        }
    }
}
