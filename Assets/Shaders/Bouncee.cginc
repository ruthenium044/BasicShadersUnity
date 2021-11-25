#include <UnityCG.cginc>

const float PI = UNITY_PI;

inline float Invert(float t)
{
    return 1 - t;
}
    
inline float Linear(float t)
{
    return t;
}

inline float SpikeLinear(float t)
{
    t = t <= 0.5f ? 2 * Linear(t) : 2 * Linear((1 - t));
    return t;
}

inline float InSine(float t)
{
    t = 1 - cos(t * PI / 2);
    return t;
}

inline float OutSine(float t)
{
    t = Invert(InSine(Invert(t)));
    return t;
}

inline float InOutSine(float t)
{
    t = InSine(2 * t) / 2;
    return t;
}

inline float SpikeSine(float t)
{
    t = t <= 0.5f ? InSine(2 * t) : 2 - InSine(2 * t);
    return t;
}

inline float InQuad(float t)
{
    t = t * t;
    return t;
}

inline float OutQuad(float t)
{
    t = Invert(InQuad(Invert(t)));
    return t;
}

inline float InOutQuad(float t)
{
    t = t <= 0.5f ? 2 * InQuad(t) : 2 * OutQuad(t) - 1;
    return t;
}

inline float SpikeQuad(float t)
{
    t = t <= 0.5f ? 4 * InQuad(t) : 4 * InQuad(t - 1);
    return t;
}

inline float InCub(float t)
{
    t = t * t * t;
    return t;
}

inline float OutCub(float t)
{
    t = Invert(InCub(Invert(t)));
    return t;
}

inline float InOutCub(float t)
{
    t = t <= 0.5 ? 4 * InCub(t) : 4 * OutCub(t) - 3;
    return t;
}

inline float SpikeCub(float t)
{
    t = t <= 0.5f ? 8 * InCub(t) : - 8 * InCub(t - 1);
    return t;
}

inline float InQuart(float t)
{
    t = t * t * t * t;
    return t;
}

inline float OutQuart(float t)
{
    t = Invert(InQuart(Invert(t)));
    return t;
}

inline float InOutQuart(float t)
{
    t = t <= 0.5f ? 8 * InQuart(t) : 8 * OutQuart(t) - 7;
    return t;
}

inline float SpikeQuart(float t)
{
    t = t <= 0.5f ? 16 * InQuart(t) : 16 * InQuart(t - 1);
    return t;
}

inline float InQuint(float t)
{
    t = t * t * t * t * t;
    return t;
}

inline float OutQuint(float t)
{
    t = Invert(InQuint(Invert(t)));
    return t;
}

inline float InOutQuint(float t)
{
    t = t <= 0.5f ? 16 * InQuint(t) : 16 * OutQuint(t) - 15;
    return t;
}

inline float SpikeQuint(float t)
{
    t = t <= 0.5f ? 32 * InQuint(t) : - 32 * InQuint(t - 1);
    return t;
}

inline float InExpo(float t)
{
    t = 1 - sqrt(1 - t);
    return t;
}

inline float OutExpo(float t)
{
    t = sqrt(t);
    return t;
}

inline float InOutExpo(float t)
{
    t = t <= 0.5f ? 0.5f - sqrt(1 - 2 * t) / 2 : sqrt(2 * t - 1) / 2 + 0.5f;
    return t;
}

inline float SpikeExpo(float t)
{
    t = t <= 0.5f ? 1 - sqrt(1 - 2 * t) : 1 - sqrt(2 * t - 1);
    return t;
}

inline float InCircular(float t)
{
    t = 1 - sqrt(1 - t * t);
    return t;
}

inline float OutCircular(float t)
{
    t = sqrt(1 - (t - 1) * (t - 1));
    return t;
}

inline float InOutCircular(float t)
{
    t = t < 0.5f ? 0.5f - sqrt(0.25f - t * t) : sqrt(0.25f - (t - 1) * (t - 1)) + 0.5f;
    return t;
}

inline float SpikeCircular(float t)
{
    t = t < 0.5f ? 1 - sqrt(1 - 4 * pow(t, 2)) : 1 - sqrt(1 - pow(2 * t - 2, 2));
    return t;
}

inline float OutBounce(float t)
{
    const float offset = 2.75f;
    const float scalar = 7.5625f;

    if (t < 1 / offset)
    {
        t = scalar * t * t;
    }
    else if (t < 2 / offset)
    {
        t = scalar * InQuad(t - 1.5f / offset) + 0.75f;
    }
    else if (t < 2.5f / offset)
    {
        t = scalar * InQuad(t - 2.25f / offset) + 0.9375f;
    }
    else
    {
        t = scalar * InQuad(t - 2.625f / offset) + 0.984375f;
    }
    return t;
}

inline float InBounce(float t)
{
    t = Invert(OutBounce(Invert(t)));
    return t;
}

inline float InOutBounce(float t)
{
    t = t < 0.5f ? Invert(OutBounce(1 - 2 * t)) / 2 : OutBounce(2 * t - 1) / 2 + 0.5f;
    return t;
}

inline float SpikeBounce(float t)
{
   t = t < 0.5f ? Invert(OutBounce(1 - 2 * t)) : Invert(OutBounce( 2 * t - 1));
    return t;
}

inline float InElastic(float t, float amplitude, float period)
{
    if (t <= 0.0f)
    {
        return 0;
    }
    if (t >= 1.0f)
    {
        return 1;
    }
    t = - InQuad(t * amplitude) * sin((t - 0.75f) * 2 * PI * period);
    return t;
}

inline float InElastic(float t)
{
    t = InElastic(t, 1.0f, 3.0f);
    return t;
}

inline float OutElastic(float t)
{
    t = Invert(InElastic(Invert(t)));
    return t;
}

inline float InOutElastic(float t)
{
    const float amplitude = 1.0f * 2.0f;
    const float period = 3.0f * 1.645f;
    t = t <= 0.5f ? InElastic(t, amplitude, period) / 2 : Invert(InElastic(Invert(t), amplitude, period)) / 2 + 0.5f;
    return t;
}

inline float SpikeElastic(float t)
{
    const float amplitude = 1.0f * 2.0f;
    const float period = 3.0f * 1.645f;
    t = t <= 0.5f ? InElastic(t, amplitude, period) :  InElastic(Invert(t), amplitude, period);
    return t;
}

inline float InBack(float t)
{
    const float a = 1.70158f;
    t = (a + 1) * InCub(t) - a * t * t;
    return t;
}

inline float OutBack(float t)
{
    t = Invert(InBack(Invert(t)));
    return t;
}

inline float InOutBack(float t)
{
    const float p = 1.75f;
    t = t <= 0.5f ? InBack(p * t) : Invert(InBack(p * Invert(t)));
    return t;
}

inline float SpikeBack(float t)
{
    const float p = 2.0f;
    t = t <= 0.5f ? InBack(p * t) : InBack(p * Invert(t));
    return t;
}

