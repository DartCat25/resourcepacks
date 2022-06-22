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
in float shadow;

out vec4 fragColor;
out float gl_FragDepth;

void main() {
    gl_FragDepth = gl_FragCoord.z - 0.001;

    vec4 color = texture(Sampler0, texCoord0);

    if (color.a <= 0.1 && shadow != 0)
    {
        color = texture(Sampler0, texCoord0 + vec2(-1) / textureSize(Sampler0, 0));
        color.rgb /= 4;
        gl_FragDepth += 0.001;
    }

    color *= vertexColor * ColorModulator;

    if (color.a < 0.1) {
        discard;
    }
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
