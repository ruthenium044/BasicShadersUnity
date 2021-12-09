Shader "Custom/Glass"
{
	Properties
	{
		MainTex ("Texture", 2D) = "white" {}
		BumpMap ("BumpMap", 2D) = "bump" {}
		ScaleUV ("Scale", Range(1,100)) = 1
	}
	SubShader
	{
		Tags{ "Queue" = "Transparent"}
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
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 uvgrab: TEXCOORD1;
				float2 uvbump: TEXCOORD2;
				float4 vertex : SV_POSITION;
			};

			sampler2D MainTex;
			float4 MainTex_ST;
			sampler2D BumpMap;
			float4 BumpMap_ST;
			
			sampler2D _GrabTexture;
			float4 _GrabTexture_TexelSize;
			float ScaleUV;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uvgrab.xy = (float2(o.vertex.x, -o.vertex.y) + o.vertex.w) * 0.5f;
				o.uvgrab.zw = o.vertex.zw;
				o.uv = TRANSFORM_TEX(v.uv, MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half2 bump = UnpackNormal(tex2D( BumpMap, i.uvbump )).rg; 
				float2 offset = bump * ScaleUV * _GrabTexture_TexelSize.xy;
				i.uvgrab.xy = offset * i.uvgrab.z + i.uvgrab.xy;
				
				fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
				fixed4 tint = tex2D(MainTex, i.uv);
				col *= tint;
				return col;
			}
			ENDCG
		}
	}
}
