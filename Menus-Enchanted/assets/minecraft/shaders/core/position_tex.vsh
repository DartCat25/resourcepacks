#version 150

//Code by DartCat25
//https://www.planetminecraft.com/texture-pack/menus-enchanted/

in vec3 Position;
in vec2 UV0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out vec2 texCoord0;
out vec4 vertexColor;
out float isNeg;
out vec2 ScrSize;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    texCoord0 = UV0;
    isNeg = float(UV0.y < 0);
    ScrSize = 2 / vec2(ProjMat[0][0], -ProjMat[1][1]);
}
