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
in vec4 normal;

flat in int wit;
in vec4 uv1, uv2;
in vec2 corner;

out vec4 fragColor;

void main() {
    #moj_import <rem_sides.glsl>

    vec4 color = texture(Sampler0, coord) * vertexColor * ColorModulator;
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
