Shader "Unlit/SceneDepth"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        DepthPower ("Depth power", Range(1, 5)) = 1
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest

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

            sampler2D _MainTex;
            fixed DepthPower;
            sampler2D _CameraDepthTexture;

             fixed4 frag (v2f_img i) : COLOR
            {
                float d = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv.xy));
                d = pow(Linear01Depth(d), DepthPower);
                return d;
            }
            ENDCG
        }
    }
}
