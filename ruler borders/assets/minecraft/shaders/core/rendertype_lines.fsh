#version 150

#define SIZE 8

#moj_import <fog.glsl>

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform float GameTime;

in float vertexDistance;
in vec4 vertexColor;

in vec4 pos1, pos2;
flat in vec4 pos3;
in vec2 inCoord;

out vec4 fragColor;

int digimap[] = int[](188, 1007, 240, 883, 2, 925, 121, 894, 657, 325, 130, 889, 46, 1007, 22);

vec4 drawDigit(ivec2 offset, ivec2 pos, int d)
{
    pos -= offset;
    if (clamp(pos, ivec2(0), ivec2(2, 4)) != pos)
        return vec4(0);
    int col = (digimap[pos.x + pos.y * 3] >> d) & 1;
    return vec4(col);
}

vec4 drawNumber(ivec2 offset, ivec2 pos, float n)
{
    if (n == 0) return drawDigit(offset, pos, 0);

    int p = 0;
    float s = n;
    while (s != int(s) && p < 5)
    {
        p += 1;
        s *= 10;
    }
    int r = int(s);

    vec4 digits = vec4(0);

    if (p != 0)
        digits += vec4(pos - offset == vec2(3-p * 4, 5));

    if (n < 1)
    {
        digits += drawDigit(offset - ivec2(p * 4, 0), pos, 0);
    }
        
    while (r > 0)
    {
        digits += drawDigit(offset, pos, r % 10);
        r /= 10;
        offset.x -= 4;
    }
    return digits;
}

void main() {
    vec4 color = vertexColor * ColorModulator;

    if(color.a <= 0.5)
    {
        vec3 pos = pos3.w == 0 ? pos1.xyz / pos1.w : pos2.xyz / pos2.w;

        float length = round(length(pos - pos3.xyz) * 0x1000) / 0x1000;

        color = (int(color.r * SIZE * length * (float(length <= 0.51) + 1)) % 2 == 0 ? vec4(1, 1, 0, 0.9) : vec4(0, 0, 0, 0.9));

        if (abs(inCoord.x - 0.5) > 0.1) color.a = 0;

        color += drawNumber(ivec2(-24*round(length*1000)/1000, 1), ivec2((inCoord.yx * 15) * vec2(-4 * length, 1)), length);
        //color += drawNumber(ivec2(-24*round(length*1000)/1000, -13), ivec2((inCoord.yx * 15) * vec2(-4 * length, -1)), length);

        if (color.a == 0) discard;
    }

    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
