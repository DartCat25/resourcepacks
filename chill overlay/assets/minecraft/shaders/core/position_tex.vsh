#version 150

in vec3 Position;
in vec2 UV0;

uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out vec2 texCoord0;
out float snow;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    texCoord0 = UV0;

    snow = 0;
    if (texelFetch(Sampler0, ivec2(255, 127), 0).rgb == vec3(106, 204, 230) / 255)
        snow = 1;
}
