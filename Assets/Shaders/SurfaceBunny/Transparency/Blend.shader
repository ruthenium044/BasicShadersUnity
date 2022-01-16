Shader "Custom/Blend"
{
    Properties
    {
        MainTex ("Albedo (RGB)", 2D) = "black" {}
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        LOD 200
        
        Blend OneMinusSrcColor OneMinusSrcColor	
        Cull Off
        Pass
        {
            SetTexture [MainTex] { combine texture }
        }
    }
    FallBack "Diffuse"
}
