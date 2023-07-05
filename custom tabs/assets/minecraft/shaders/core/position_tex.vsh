#version 150

in vec3 Position;
in vec2 UV0;

uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out vec2 texCoord0;

void main() {

    vec3 Pos = Position;

    if (texelFetch(Sampler0, ivec2(255), 0) == vec4(1, 0, 0, 1))
        Pos.z += 300;

    gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);

    texCoord0 = UV0;
}
