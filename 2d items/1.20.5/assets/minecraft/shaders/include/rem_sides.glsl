vec2 coord = texCoord0;

if (wit >= 1)
{
    vec2 UV1 = round(uv1.xy / uv1.z);
    vec2 UV2 = round(uv2.xy / uv2.z);

    vec2 stp = min(UV1, UV2);
    vec2 res = (max(UV1, UV2) - stp) / 2;

    vec2 res2 = vec2(UV2.x - UV1.x, UV2.y - UV1.y);

    if (res2.x <= 1 || res2.y <= 1)
        discard;

    if (wit == 1)
    {
        coord = (vec2(stp + res) - corner * res) / textureSize(Sampler0, 0);
    }
}