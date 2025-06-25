#version 150

// Can't moj_import in things used during startup, when resource packs don't exist.
// This is a copy of dynamicimports.glsl
layout(std140) uniform DynamicTransforms {
    mat4 ModelViewMat;
    vec4 ColorModulator;
    vec3 ModelOffset;
    mat4 TextureMat;
    float LineWidth;
};
layout(std140) uniform Projection {
    mat4 ProjMat;
};

uniform sampler2D Sampler0;

in vec4 vertexColor;
in vec2 texCoord0;
in vec2 helpCoord;
in vec2 p1, p2;
flat in int type, num;
flat in vec4 tint;
flat in int bilinear;

out vec4 fragColor;

vec4 Bilinear(sampler2D Sampler, vec2 uv)
{
    ivec2 iuv = ivec2(uv);
    vec2 fuv = fract(uv);
    vec2 fuvi = 1 - fuv;

    vec4 ul = texelFetch(Sampler, iuv + ivec2(0, 0), 0);
    vec4 dl = texelFetch(Sampler, iuv + ivec2(0, 1), 0);

    vec4 ur = texelFetch(Sampler, iuv + ivec2(1, 0), 0);
    vec4 dr = texelFetch(Sampler, iuv + ivec2(1, 1), 0);

    return ul*fuvi.x*fuvi.y + dl*fuvi.x*fuv.y + ur*fuv.x*fuvi.y + dr*fuv.x*fuv.y;
}

vec4 sample(vec4 col, vec2 uv, vec2 offset, vec2 pos, vec2 size, vec4 tint)
{
    uv -= offset;
    if (clamp(uv, vec2(0), size) == uv)
    {
        vec4 sam = texelFetch(Sampler0, ivec2(pos + uv), 0) * tint;
        col = vec4(mix(col.rgb, sam.rgb, sam.a), col.a + sam.a);
    }

    return col;
}

void main() {
    gl_FragDepth = gl_FragCoord.z;

    vec2 uv = texCoord0 * textureSize(Sampler0, 0);

    vec4 color = texture(Sampler0, texCoord0) * vertexColor;
    if (bilinear == 1 && color.a != 252 / 255.0)
        color = Bilinear(Sampler0, uv);

    float p = 0;

    switch (type)
    {
        case 1:
            vec4 glPos = ProjMat * ModelViewMat * vec4(0, 0, num * 0.5 + 1000, 1);
            float depth = (glPos.z / glPos.w) * 0.5 + 0.5;
            gl_FragDepth = depth;
        break;
        case 2:
            glPos = ProjMat * ModelViewMat * vec4(0, 0, min(num/helpCoord.y * 0.5, 1000)-1 + 1000, 1);
            depth = (glPos.z / glPos.w) * 0.5 + 0.5;
            gl_FragDepth = depth;
            color *= tint;
        break;
        case 3:
            int maxHP = num;
            while (maxHP > 0)
            {
                color = sample(color, uv, vec2(670 + 19 - p + int(num > 9) * 6, 234), vec2(670 + maxHP % 10 * 8, 212), vec2(5, 7), tint);
                maxHP /= 10;
                p += 6;
            }
        break;
        case 4:
            int HP = num;
            while (HP > 0)
            {
                color = sample(color, uv, vec2(670 + 7 - p, 234), vec2(670 + HP % 10 * 8, 212), vec2(5, 7), tint);
                HP /= 10;
                p += 6;
            }
        break;
        case 5:
            int armorHP = num;
            while (armorHP > 0)
            {
                color = sample(color, uv, vec2(670 + 7 - p, 241), vec2(670 + armorHP % 10 * 8, 212), vec2(5, 7), tint);
                armorHP /= 10;
                p += 6;
            }
        break;
        case 6:
            int airHP = num;
            while (airHP > 0)
            {
                color = sample(color, uv, vec2(670 + 10 - p, 151), vec2(670 + airHP % 10 * 8, 212), vec2(5, 7), tint);
                airHP /= 10;
                p += 6;
            }
        break;
        case 7:
            if (p1.y == 0)
                discard;
            float P1 = round(p1.x / p1.y);
            float P2 = round(p2.x / p2.y);

            float progress = abs(P2 - P1) / 182;
            if (1 - progress > helpCoord.x)
                discard;
        break;
    }

    if (color.a <= 0.01) discard;

    fragColor = color * ColorModulator;
}
