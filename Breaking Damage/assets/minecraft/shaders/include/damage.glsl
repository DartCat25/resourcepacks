vec4 damageColor = overlayColor;

if (damageColor.a <= 0.8 && damageColor.a > 0.0)
{
    vec2 texSize = textureSize(Sampler0, 0);
    ivec2 uv = ivec2(texCoord0 * texSize);
    int n = uv.x % 16 + (uv.y % 16) * 16;
    damageColor = colors[bitmap[n % 256]];
}

color.rgb = damageColor.rgb * color.rgb;