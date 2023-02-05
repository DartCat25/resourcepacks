#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec2 UV0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform mat4 TextureMat;
uniform int FogShape;
uniform float FogStart;

out float vertexDistance;
out vec2 texCoord0;
out vec3 Pos;
out float isGUI;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    texCoord0 = (TextureMat * vec4(UV0, 0.0, 1.0)).xy;

    if (ProjMat[3].x == -1)
        isGUI = 2;
    else if (FogStart > 100000)
        isGUI = 1;
    else
        isGUI = 0;

    Pos = Position;
}
