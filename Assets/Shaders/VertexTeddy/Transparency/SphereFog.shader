Shader "Unlit/SphereFog"
{
    Properties
    {
        Radius("Radius", Range(0, 1)) = 0.5
        FogColor("Fog Colour", Color) = (1,1,1,1)
        InnerRatio ("Inner Ratio", Range (0.0, 0.9)) = 0.5
        FogDensity("Density", Range (0.0, 1.0)) = 0.5
        SpaceOffset ("Offset", Vector) = (0, 0, 0, 0)
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off Lighting Off ZWrite Off
        ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
           
            float CalculatFogIntensity(float3 sphereCentre, float sphereRadius, float innerRatio,
                float density, float3 cameraPosition, float3 viewDirection, float maxDistance)
            {
                float3 localCam = cameraPosition - sphereCentre;
                float a = dot (viewDirection, viewDirection);
                float b = 2 * dot (viewDirection, localCam);
                float c = dot(localCam, localCam) - sphereRadius * sphereRadius;
                float d = b * b - 4 * a * c;
                
                if(d <= 0.0f)
                    return 0;
                    
                float DSqrt = sqrt(d);
                float dist = max(( -b - DSqrt)/2*a, 0);
                float dist2 = max (( -b + DSqrt)/2*a, 0);
                
                float backDepth = min (maxDistance, dist2);
                float stepDistance = (backDepth - dist)/ 10;
                float centerValue = 1/(1 - innerRatio);
                
                float clarity = 1;
                for( int seg = 0; seg < 10; seg++)
                {
                    float3 position = localCam + viewDirection * dist;
                    float val = saturate(centerValue * (1 - length(position)/sphereRadius));
                    float fogAmount = saturate(val * density);
                    clarity *= (1 - fogAmount);
                    dist += stepDistance;
                }
                return 1 - clarity;
            }

            struct v2f
            {
                float3 view : TEXCOORD0;
                float4 pos : SV_POSITION;
                float4 projPos : TEXCOORD1;
                float3 origin : TEXCOORD2;
            };

            float Radius;
            fixed4 FogColor;
            float InnerRatio;
            float FogDensity;
            float3 SpaceOffset;
            sampler2D _CameraDepthTexture;

            v2f vert (appdata_base v)
            {
                v2f o;
                float4 wPos = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
                o.view = wPos.xyz - _WorldSpaceCameraPos;
                o.projPos = ComputeScreenPos(o.pos);
                
                float inFrontOf = (o.pos.z/o.pos.w) > 0;
                o.pos.z *= inFrontOf;
                o.origin = UNITY_MATRIX_M._m03_m13_m23; 
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half4 color = half4 (1,1,1,1);
                float depth = LinearEyeDepth (UNITY_SAMPLE_DEPTH (tex2Dproj(_CameraDepthTexture,
                                                    UNITY_PROJ_COORD (i.projPos))));
                float3 viewDir = normalize (i.view);

                float fog = CalculatFogIntensity (i.origin + SpaceOffset, Radius,
                                InnerRatio, FogDensity, _WorldSpaceCameraPos,
                                viewDir,depth);

                color.rgb = FogColor.rgb;
                color.a = fog;
                return color;
            }
            ENDCG
        }
    }
}
