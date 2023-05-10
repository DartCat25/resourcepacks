#version 150

in vec3 Position;
in vec2 UV0;
in vec4 Color;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

uniform vec2 ScreenSize;
uniform sampler2D Sampler0;

out vec2 texCoord0;
out vec4 vertexColor;
out vec4 Pos;
out float isNeg;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    
    vertexColor = vec4(1);
    if (texelFetch(Sampler0, ivec2(0), 0).a == 254 / 255.0)
    {
        vec2 texSize = textureSize(Sampler0, 0);
        float texRatio = texSize.x / texSize.y;
        float ScrRatio = ScreenSize.y / ScreenSize.x;
        float RatioRatio = ScrRatio * texRatio;

        if (RatioRatio < 1)
            texCoord0 = (gl_Position.xy * vec2(1, RatioRatio) * vec2(0.5, -0.5) + 0.5);
        else
            texCoord0 = (gl_Position.xy * vec2(1 / RatioRatio, 1) * vec2(0.5, -0.5) + 0.5);
    }
    else
        texCoord0 = UV0;
}
