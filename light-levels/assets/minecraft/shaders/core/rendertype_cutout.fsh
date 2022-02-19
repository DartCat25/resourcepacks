#version 150

#moj_import <config.glsl>
#moj_import <fog.glsl>

#define INNER 0.03 * vertexDistance / 10

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec4 normal;
in vec2 light;
in vec4 Pos;
in vec4 Norm;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;

    if (color.a == 0)
        discard;

    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);

    float intLight = round(light.x);

    vec3 pos = Pos.xyz - ceil(Pos.xyz - 1);
    pos.xz = abs(Pos.xz - ceil(Pos.xz));


    #ifdef FULL_BLOCKS
        bool isPos = Norm.y > 0.9;

        if (intLight <= MIN_YELLOW && intLight > MIN_RED && isPos)
            fragColor = mix(fragColor, vec4(1, 1, 0, 1), 0.3);
        if (intLight <= MIN_RED && isPos)
            fragColor = mix(fragColor, vec4(1, 0, 0, 1), 0.3);
    #else
        bool isPos = Norm.y > 0.9 && (pos.x < INNER || pos.z < INNER || 1 - pos.x < INNER || 1 - pos.z < INNER) && vertexDistance <= 50;

        if (intLight <= MIN_YELLOW && isPos)
            fragColor = vec4(1, 1, 0, 1);
        if (intLight <= MIN_RED && isPos)
            fragColor = vec4(1, 0, 0, 1);
    #endif
}
