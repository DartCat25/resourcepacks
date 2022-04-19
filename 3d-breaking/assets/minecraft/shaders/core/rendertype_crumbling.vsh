#version 150

#define DEPTH 0.5 //Depth in pixels (1/16 of block);

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in vec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;

out vec4 vertexColor;
out vec2 texCoord0;
out vec2 texCoord2;

out vec3 Pos;
out vec3 rNormal;
out mat3 mat;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    Pos = Position;

    vec2 texSize = textureSize(Sampler0, 0);

    vertexColor = Color;
    texCoord0 = UV0;
    texCoord2 = UV2;

    rNormal = normalize(IViewRotMat * Normal);

    vec3 xVec, yVec;

    if (abs(rNormal.y) >= 0.9)
    {
        yVec = vec3(0, 0, -1) * IViewRotMat;
        xVec = vec3(1, 0, 0) * IViewRotMat;
    }
    else
    {
        yVec = vec3(0, 1, 0) * IViewRotMat;
        xVec = cross(Normal, yVec);
    }

    mat = mat3(xVec, yVec, Normal); 
}