Shader "Unlit/Clouds"
{
    Properties
    {
        Scale ("Scale", Range(0.1, 10)) = 2
        StepScale ("StepScale", Range(0.1, 100)) = 1
        Steps ("Steps", Range(1, 200)) = 60
        MinHeight ("MinHeight", Range(0, 5)) = 0
        MaxHeight ("MaxHeight", Range(6, 10)) = 0
        FadeDist ("FadeDist", Range(0, 5)) = 0
        SunDir ("SunDir", Vector) = (1, 0, 0, 0)
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

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 view : TEXCOORD1;
                float4 projPos : TEXCOORD2;
                float3 wpos : TEXCOORD3;
            };

            float Scale;
            float StepScale;
            float Steps;
            float MinHeight;
            float MaxHeight;
            float FadeDist ;
            float4 SunDir;
            sampler2D _CameraDepthTexture;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.wpos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.view = o.wpos - _WorldSpaceCameraPos;
                o.projPos = ComputeGrabScreenPos(o.pos);
                return o;
            }

            fixed4 integrate(fixed4 sum, float diffuse, float density, fixed4 bgcol, float t)
            {
                fixed3 lighting = fixed3(0.65, 0.68, 0.7) * 1.3 + 0.5 * fixed3(0.7, 0.5 ,0.3) * diffuse;
                fixed3 colorgb = lerp(fixed3(1.0, 0.95, 0.8), fixed3(0.65, 0.65, 0.65), density);
                fixed4 col = fixed4(colorgb.rgb, density);
                col.rgb *= lighting;
                col.rgb = lerp(col.rgb, bgcol.rgb, 1 - exp(-0.003 * t * t));
                col.a *= 0.5;
                col.rgb *= col.a;
                return sum + col * (1 - sum.a);
            }

            #define MARCH(steps, noiseMap, cameraPos, viewDir, bgcol, sum, depth, t) { \
                for (int i = 0; i < steps  + 1; i++) \
                { \
                    if(t > depth) \
                        break; \
                    float3 pos = cameraPos + t * viewDir; \
                    if (pos.y < MinHeight || pos.y > MaxHeight || sum.a > 0.99) \
                    {\
                        t += max(0.1, 0.02*t); \
                        continue; \
                    }\
                    \
                    float density = noiseMap(pos); \
                    if (density > 0.01) \
                    { \
                        float diffuse = clamp((density - noiseMap(pos + 0.3 * SunDir)) / 0.6, 0.0, 1.0);\
                        sum = integrate(sum, diffuse, density, bgcol, t); \
                    } \
                    t += max(0.1, 0.02 * t); \
                } \
            }

            #define NOISEPROC(N, P) 1.75 * N * saturate(MaxHeight - P.y) / FadeDist
            
            float random(float3 value, float3 dotDir)
            {
                float3 smallV = sin(value);
                float random = dot(smallV, dotDir);
                random = frac(sin(random) * 1234567.1234);
                return random;
            }

            float3 random3d(float3 value)
            {
                return float3(random(value, float3(12.898, 68.4, 35.344)),
                            random(value, float3(50.898, 78.4, 8.344)), 
                            random(value, float3(10.898, 468.4, 20.344)));
            }

            float noise3d(float3 value)
            {
                value *= Scale;
                float3 interp = frac(value);
                interp = smoothstep(0, 1, interp);

                float3 ZValues[2];
                for (int z = 0; z <= 1; z++)
                {
                    float3 YValues[2];
                    for (int y = 0; y <= 1; y++)
                    {
                        float3 XValues[2];
                        for (int x = 0; x <= 1; x++)
                        {
                            float3 cell = floor(value) + float3(x, y, x);
                            XValues[x] = random3d(cell);
                        }
                        YValues[y] = lerp(XValues[0], XValues[1], interp.x);
                    }
                    ZValues[z] = lerp(YValues[0], YValues[1], interp.y);
                }
                float noise = -1 + 2 * lerp(ZValues[0], ZValues[1], interp.z);
                return noise;
            }
            
            float map1(float3 q)
            {
                float3 p = q;
                float f;
                f = 0.5f * noise3d(q);
                q = q * 2;
                f += 0.25f * noise3d(q);
                return NOISEPROC(f, p);
            }

            float map2(float3 q)
            {
                float3 p = q;
                float f;
                f = 0.5f * noise3d(q);
                q = q * 2;
                f += 0.25f * noise3d(q);
                q = q * 3;
                f += 0.125f * noise3d(q);
                return NOISEPROC(f, p);
            }

            float map3(float3 q)
            {
                float3 p = q;
                float f;
                f = 0.5f * noise3d(q);
                q = q * 2;
                f += 0.25f * noise3d(q);
                q = q * 3;
                f += 0.125f * noise3d(q);
                q = q * 4;
                f += 0.06f * noise3d(q);
                return NOISEPROC(f, p);
            }

            float map4(float3 q)
            {
                float3 p = q;
                float f;
                f = 0.5f * noise3d(q);
                q = q * 2;
                f += 0.25f * noise3d(q);
                q = q * 3;
                f += 0.125f * noise3d(q);
                q = q * 4;
                f += 0.0642f * noise3d(q);
                q = q * 5;
                f += 0.035234f * noise3d(q);
                return NOISEPROC(f, p);
            }

            float map5(float3 q)
            {
                float3 p = q;
                float f;
                f = 0.5f * noise3d(q);
                q = q * 2;
                f += 0.25f * noise3d(q);
                q = q * 3;
                f += 0.125f * noise3d(q);
                q = q * 4;
                f += 0.0642f * noise3d(q);
                q = q * 5;
                f += 0.035234f * noise3d(q);
                q = q * 6;
                f += 0.015234f * noise3d(q);
                return NOISEPROC(f, p);
            }

            fixed4 Raymarch(float3 camPos, float3 viewDir, fixed4 bgColor, float depth)
            {
                fixed4 col = fixed4(0, 0, 0, 0);
                float ct = 0;
                MARCH(Steps, map1, camPos, viewDir, bgColor, col, depth, ct);
                MARCH(Steps, map2, camPos, viewDir, bgColor, col, depth * 2, ct);
                MARCH(Steps, map3, camPos, viewDir, bgColor, col, depth * 3, ct);
                MARCH(Steps, map4, camPos, viewDir, bgColor, col, depth * 4, ct);
                MARCH(Steps, map5, camPos, viewDir, bgColor, col, depth * 5, ct);
                return clamp(col, 0, 1);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float depth = 1;
                depth *= length(i.view);
                fixed4 col = fixed4(1, 1, 1, 0);
                fixed4 clouds = Raymarch(_WorldSpaceCameraPos, normalize(i.view) * StepScale, col, depth);
                fixed3 mixed = col * (1.0 - clouds.a) + clouds.rgb;
                return fixed4(mixed, clouds.a);
            }
            ENDCG
        }
    }
}
