#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec2 texCoord1;
flat in vec4 tint;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    if (color.a < 0.1) {
        discard;
    }

    if ((tint.a == 2 && round(color.a * 255) == 252) || tint.a != 2)
        color *= vec4(tint.rgb, 1);
    if (round(color.a * 255) == 252)
        color.a = 1;


    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
