// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/Wireframe"
{
    Properties
    {
        MainColor ("Color", Color) = (0,0,0,0)
        EdgeColor ("Edge Color", Color) = (0,1,0,1)
        Width ("Width", float) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            //Cull Front
            AlphaTest Greater 0.5
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            float4 EdgeColor;
            float4 MainColor;
            float Width;
            
            struct appdata
            {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 color : COLOR;
            };
            
            struct v2f
            {
                float4 pos : POSITION;
                float4 texcoord : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 color : COLOR;
            };
            
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.texcoord = v.vertex;
                return o;
            }
            
            fixed4 frag (v2f i) : COLOR
            {
                float lx = step(Width, i.texcoord.x);
                float ly = step(Width, i.texcoord.y);
                float hx = step(i.texcoord.x, 1.0 - Width);
                float hy = step(i.texcoord.y, 1.0 - Width);
                
                fixed4 col;
                col = lerp(EdgeColor, MainColor, lx * ly * hx * hy);
                return col;
            }
            ENDCG
        }

    }
}
