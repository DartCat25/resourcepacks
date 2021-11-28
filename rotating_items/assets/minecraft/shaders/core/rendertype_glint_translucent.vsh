#version 150

#moj_import <matf.glsl>
#moj_import <config.glsl>

#define NONORMALS

in vec3 Position;
in vec2 UV0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat4 TextureMat;

uniform float GameTime;
uniform vec2 ScreenSize;

out float vertexDistance;
out vec2 texCoord0;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
    texCoord0 = (TextureMat * vec4(UV0, 0.0, 1.0)).xy;

    #moj_import <rotation.glsl>
}
