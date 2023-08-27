#version 150

in vec3 Position;
in vec4 Color;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out vec4 vertexColor;

void main() {

    vec3 Pos = Position;

    if (Color.a == 1 && (Color.rgb == vec3(1) || Color.rgb == vec3(0) || Color.rgb == vec3(192 / 255.0) || Color.rgb == vec3(128 / 255.0)))
    {
        Pos.z += 0.001;
    }


    gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);

    vertexColor = Color;
}
