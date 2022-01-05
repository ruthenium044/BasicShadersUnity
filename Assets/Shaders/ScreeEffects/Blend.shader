Shader "Unlit/Blend"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        BlendTex ("Blend texture", 2D) = "white" {}
        Opacity ("Blend Opacity", Range(0, 1)) = 1
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest

            #pragma multi_compile _OVERLAY_NONE _OVERLAY_MULTIPLY _OVERLAY_ADD _OVERLAY_SCREEN _OVERLAY_OVERLAY
            
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
            sampler2D BlendTex;
            fixed Opacity;

            fixed OverlayBlendMode(fixed basePixel, fixed blendPixel)
            {
                if (basePixel < 0.5)
                {
                    return 2 * basePixel * blendPixel;
                }
                return 1 - 2 * (1 - basePixel) * (1 - blendPixel);
            }
            
            fixed4 frag (v2f_img i) : COLOR
            {
                fixed4 renderTex = tex2D(_MainTex, i.uv);
                fixed4 blendTex = tex2D(BlendTex, i.uv);
                fixed4 blended = renderTex;
                
                #if _OVERLAY_MULTIPLY
                blended = renderTex * blendTex;
                
                #elif _OVERLAY_ADD
                blended = renderTex + blendTex;
                
                #elif _OVERLAY_SCREEN
                blended = (1.0 - ((1.0 - renderTex) * (1.0 - blendTex)));

                #elif _OVERLAY_OVERLAY
                blended.r = OverlayBlendMode(renderTex.r, blendTex.r);
                blended.g = OverlayBlendMode(renderTex.g, blendTex.g);
                blended.b = OverlayBlendMode(renderTex.b, blendTex.b);
                #endif
                
                renderTex = lerp(renderTex, blended, Opacity);
                return renderTex;
            }
            ENDCG
        }
    }
}
