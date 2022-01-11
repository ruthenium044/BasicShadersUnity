Shader "Unlit/Water"
{
    Properties
    {
        NoiseTex ("NoiseTex", 2D) = "white" {}
        MainColor ("Color", Color) = (1, 1, 1, 1)
        
        Period ("Period", Range(0, 50)) = 0.05
        Magnitude ("Magnitude", Range(0, 0.5)) = 0.05
        Scale ("Scale", Range(0, 10)) = 1
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" 
             "Queue" = "Transparent"
                "IgnoreProjector" = "True" }
        
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
                float4 vertex : POSITION;
                fixed4 color : COLOR;
                float2 texcoord : TEXCOORD0;
                float4 worldPos : TEXCOORD1;
                float4 uvgrab : TEXCOORD2;
            };

            sampler2D NoiseTex;
            fixed4 MainColor;
            sampler2D _GrabTexture;
            
            float Period; 
            float Magnitude;
            float Scale;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uvgrab = ComputeGrabScreenPos(o.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : COLOR
            {
                float sinT = sin(_Time.w / Period);
                float2 distortion = float2(tex2D(NoiseTex, i.worldPos.xy / Scale + float2(sinT, 0)).r - 0.5,
                                           tex2D(NoiseTex, i.worldPos.xy / Scale + float2(0, sinT)).r - 0.5);
                i.uvgrab.xy += distortion * Magnitude;
                fixed4 col = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
                return col * MainColor;
            }
            ENDCG
        }
    }
}
