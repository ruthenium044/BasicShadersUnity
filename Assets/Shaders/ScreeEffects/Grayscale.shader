Shader "Unlit/Grayscale"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        LuminosityAmount ("Grayscale amount", Range(0, 1)) = 1
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

            uniform sampler2D _MainTex;
            uniform fixed LuminosityAmount;
            
            fixed4 frag (v2f_img i) : COLOR
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                float luminosity = 0.299 * col.r + 0.587 * col.g + 0.114 * col.b;
                float3 lum = (luminosity, luminosity, luminosity);
                
                fixed4 finalCol = col;
                finalCol.rgb = lerp(col.rgb, lum, LuminosityAmount);
                return finalCol;
            }
            ENDCG
        }
    }
}
