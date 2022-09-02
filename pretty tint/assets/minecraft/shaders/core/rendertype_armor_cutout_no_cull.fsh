#version 150

#moj_import <fog.glsl>
#moj_import <hue.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec2 texCoord1;
in vec4 normal;
in vec4 tint;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0);

    if (color.a < 0.1)
        discard;

    if (tint.a == 0)
    {
        vec3 hsv = RGBtoHSV(tint.rgb * color.rgb);
        vec3 rgb = hue(hsv.r);
        float luma = rgb.r * 0.299 + rgb.g * 0.587 + rgb.b * 0.114;
        hsv.r = fract(hsv.r + sign(sin((hsv.r - 1 / 6.0) * PI * 2)) * 0.2 * (1 - color.r) * luma);
        hsv.g += (0.5 - color.r) * 0.1 * luma;
        color.rgb = HSVtoRGB(hsv);
    }
    color *= vertexColor * ColorModulator;
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
