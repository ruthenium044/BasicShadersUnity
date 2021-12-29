Shader "Unlit/Glass2"
{
    Properties
    {
        MainColor ("Color", Color) = (1,1,1,1)
        MainTex ("Albedo (RGB)", 2D) = "white" {}
        BumpTex ("BumpTex", 2D) = "bump" {}
        Magnitude ("Magnitude", Range(0, 1)) = 0.05
    }
    
    SubShader
    {
        Tags { "RenderType" = "Transparent" 
             "Queue" = "Transparent"
    "       IgnoreProjector" = "True" }
        
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
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 texcoord : TEXCOORD0;
                float4 uvgrab : TEXCOORD1;
            };

            fixed4 MainColor;
            sampler2D MainTex;
            sampler2D BumpTex;
            sampler2D _GrabTexture;
            float Magnitude;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uvgrab = ComputeGrabScreenPos(o.vertex);
                o.texcoord = v.texcoord;
                return o;
            }

            fixed4 frag (v2f i) : COLOR
            {
                half4 color = tex2D(MainTex, i.texcoord);
                half4 bump = tex2D(BumpTex, i.texcoord);
                half2 distort = UnpackNormal(bump).rg;
                i.uvgrab.xy += distort * Magnitude;
                
                fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
                return col * color * MainColor;
            }
            ENDCG
        }
    }
}
