#version 150

#define COLOR vec3(0.5, 0, 0.5) //Default vec3(0.5, 0, 0.5)

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform mat3 IViewRotMat;
uniform mat4 TextureMat;

uniform float GlintAlpha;

in float vertexDistance;
in vec2 texCoord0;
in vec3 Pos;
in float isGUI;

out vec4 fragColor;

void main() {
    float fade = linear_fog_fade(vertexDistance, FogStart, FogEnd);

    if (isGUI != 2)
    {
        vec3 tPos = Pos * IViewRotMat;
        vec3 normal = normalize(cross(dFdx(tPos), dFdy(tPos)));

        vec3 refl = normalize(reflect(normalize(Pos * vec3(20, 20, 1)), normal));

        float light = dot(refl, normalize(vec3(1)));
        if (round(isGUI) != 1)
            light = light * 0.5 + 0.5;
        else
            light = max(light, 0);

        fragColor = vec4(fade * light * COLOR * GlintAlpha, 1);
    }
    else
    {
        vec4 color = texture(Sampler0, texCoord0) * ColorModulator;
        fragColor = vec4(color.rgb * fade * GlintAlpha, 1);
    }
}
