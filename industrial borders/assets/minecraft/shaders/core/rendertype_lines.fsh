#version 150

#moj_import <fog.glsl>

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform float GameTime;

in float vertexDistance;
in vec4 vertexColor;

out vec4 fragColor;

void main() {
    vec4 color = vertexColor * ColorModulator;

    if(color.a <= 0.5)
    {
        color = (int(color.r * 8.0 + GameTime * 200) % 2 == 0 ? vec4(1, 1, 0, 0.9) : vec4(0, 0, 0, 0.9));
    }

    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
