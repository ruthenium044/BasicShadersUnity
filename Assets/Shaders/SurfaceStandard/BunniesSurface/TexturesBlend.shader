Shader "Custom/TexturesBlend"
{
    Properties
    {
        MainTexture ("MainTexture (RGB)", 2D) = "white" {}
        DecalTexture ("DecalTexture (RGB)", 2D) = "white" {}
        [Toggle] ShowDecal ("Show Decal", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert
        #pragma target 3.0

        sampler2D MainTexture;
        sampler2D DecalTexture;
        float ShowDecal;

        struct Input
        {
            float2 uvMainTexture;
            float2 uvDecalTexture;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (MainTexture, IN.uvMainTexture);
            fixed4 c2 = tex2D (DecalTexture, IN.uvDecalTexture) * ShowDecal;
            o.Albedo = c.rgb + c2.rgb;
            //o.Albedo = c2.r > 0.9 ? c2.rgb : c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
