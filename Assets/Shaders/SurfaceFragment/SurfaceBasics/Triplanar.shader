Shader "Unlit/Triplanar"
{
    Properties
    {
        MainTexture ("Texture", 2D) = "white" {}
        Occlusion("Occlusion", 2D) =  "white" {}
        Tiling("Tiling", Float) = 1.0
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
                half3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                half3 normal: TEXCOORD1;
                float3 coords : TEXCOORD2;
            };

            sampler2D MainTexture;
            sampler2D Occlusion;
            float Tiling;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.coords = v.vertex.xyz * Tiling;
                o.normal = v.normal;
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half3 blend = abs(i.normal);
                blend /= dot(blend, 1.0);

                fixed4 projectionX = tex2D(MainTexture, i.coords.yz);
                fixed4 projectionY = tex2D(MainTexture, i.coords.xz);
                fixed4 projectionZ = tex2D(MainTexture, i.coords.xy);
                
                fixed4 col = projectionX * blend.x + projectionY * blend.y + projectionZ * blend.z;
                col *= tex2D(Occlusion, i.coords);
                return col;
            }
            ENDCG
        }
    }
}
