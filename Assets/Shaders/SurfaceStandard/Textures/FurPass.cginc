#pragma target 3.0

fixed4 MainColor;
sampler2D MainTex;
sampler2D ControlTex;
half Glossiness;
half Metallic;

uniform float FurLength;
uniform float Cutoff;
uniform float CutoffEnd;
uniform float EdgeFade;
uniform fixed3 Gravity;
uniform fixed GravityStrength;

//todo add control texture
void vert (inout appdata_full v)
{
    fixed3 direction = lerp(v.normal, Gravity * GravityStrength + v.normal * (1 - GravityStrength), FUR_MULTIPLIER);
    v.vertex.xyz += direction * FurLength * FUR_MULTIPLIER * v.color.a;
}

struct Input {
    float2 uvMainTex;
    float2 uvControlTex;
    float3 viewDir;
};

void surf (Input IN, inout SurfaceOutputStandard o) {
    fixed4 c = tex2D (MainTex, IN.uvMainTex) * MainColor;
    fixed4 furTex = tex2D(ControlTex, IN.uvControlTex);

    o.Albedo = c.rgb;
    o.Metallic = Metallic;
    o.Smoothness = Glossiness;
    
    //o.Alpha = step(Cutoff, c.a);
    o.Alpha = step(lerp(Cutoff, CutoffEnd, FUR_MULTIPLIER), furTex);
    float alpha = 1 - FUR_MULTIPLIER * FUR_MULTIPLIER;
    alpha *= dot(IN.viewDir, o.Normal) - EdgeFade;
    
    o.Alpha *= alpha;
}