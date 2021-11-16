#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "UnityLightingCommon.cginc"
#define USELIGHT

struct appdata
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : NORMAL;
    float4 tangent: TANGENT;
};

struct v2f
{
    float4 vertex : SV_POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : TEXCOORD1;
    float3 tangent : TEXCOORD2;
    float3 biTangent : TEXCOORD3;
    float3 worldPos : TEXCOORD4;
    LIGHTING_COORDS(5, 6)
};

sampler2D AlbedoTexture;
float4 AlbedoTexture_ST;
sampler2D NormalMap;
sampler2D HeightMap; 

float Gloss;
float NormalIntensity;
float HeightIntensity; 
float4 SurfaceColor;


v2f vert (appdata v)
{
    v2f o;

    o.uv = TRANSFORM_TEX(v.uv, AlbedoTexture); 
    float height = tex2Dlod(HeightMap, float4(o.uv, 0, 0)).x * 2 - 1;
    v.vertex.xyz += v.normal * (height * HeightIntensity);
    
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.normal = UnityObjectToWorldNormal(v.normal);
    o.tangent = UnityWorldToObjectDir(v.tangent.xyz);
    o.biTangent = cross(o.normal, o.tangent) * v.tangent.w * unity_WorldTransformParams.w; //flip n mirror handling 
    
    o.worldPos = mul(unity_ObjectToWorld, v.vertex);
    TRANSFER_VERTEX_TO_FRAGMENT(o);
    return o;
}

float4 frag (v2f i) : SV_Target
{
    float3 tex = tex2D(AlbedoTexture, i.uv).rgb;
    float3 surfaceColor = tex * SurfaceColor.rgb;
    
    #ifdef USELIGHT
        //diffuse
        float3 tangentSpaceNormal = UnpackNormal(tex2D(NormalMap, i.uv));
        tangentSpaceNormal = normalize(lerp(float3(0, 0, 1), tangentSpaceNormal, NormalIntensity));
        float3x3 tangentToWorld = {
            i.tangent.x, i.biTangent.x, i.normal.x,
            i.tangent.y, i.biTangent.y, i.normal.y,
            i.tangent.z, i.biTangent.z, i.normal.z
        };
        float3 n = mul(tangentToWorld, tangentSpaceNormal);
        
        float3 l = normalize(UnityWorldSpaceLightDir(i.worldPos));
        
        float atten = LIGHT_ATTENUATION(i);
        float3 lambert = saturate(dot(n, l));
        float3 diffuse = (lambert * atten) * _LightColor0.xyz;
                    
        //specular
        float3 v = normalize(_WorldSpaceCameraPos - i.worldPos);
        float3 h = normalize(l + v);
        const float3 specularExponent = exp2(Gloss * 6) + 2; //not great can be done in c#
        
        float3 specular = saturate(dot(h, n) * (lambert > 0));
        specular = pow(specular, specularExponent) * Gloss * atten;
        specular *= _LightColor0.xyz;
        return float4(diffuse * surfaceColor + specular, 1);
    #else
        #if IS_BASE_PASS
            return surfaceColor;
        #else
            return 0;
        #endif
    #endif
    
}
