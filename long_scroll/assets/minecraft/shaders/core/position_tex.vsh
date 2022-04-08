#version 150

#define PI 3.1415926

in vec3 Position;
in vec2 UV0;

uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out vec2 texCoord0;
out vec2 yPos;

void main() {
    ivec2 uv = ivec2(UV0 * 256);
    const vec2[4] corners = vec2[4](vec2(0), vec2(1, 0), vec2(1, 1), vec2(0, 1));
    vec2 corner = corners[(gl_VertexID) % 4];

    yPos = vec2(0);

    if (texelFetch(Sampler0, ivec2(195, 0), 0) == vec4(0, 255, 6, 255) / 255 && uv.x - corner.x * 12 == 232) //checking unused texture color and UV
    {
        ivec2 Pos = ivec2(Position.xy);
        ivec2 ScrSize = ivec2(1 / vec2(ProjMat[0][0], -ProjMat[1][1]) + 0.25);

        if (corner.y == 1)
        {
            Pos.y = ScrSize.y - 50;
        }
        else
        {
            uv.y += 95;
            yPos = vec2(Pos.y - ScrSize.y + 35, 1);
            Pos.y = ScrSize.y + 60;
        }
        
        texCoord0 = uv / 256.0;

        gl_Position = ProjMat * ModelViewMat * vec4(Pos.xy, Position.z, 1.0);

        return;
    }

    texCoord0 = UV0;

    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
}
