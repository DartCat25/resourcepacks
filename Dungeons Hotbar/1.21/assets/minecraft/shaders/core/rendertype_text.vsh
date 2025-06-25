#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;

uniform vec2 ScreenSize;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    vec3 Pos = Position;
    vec2 ScrSize = ceil(2 / vec2(ProjMat[0][0], -ProjMat[1][1]));
    const vec2[4] corners = vec2[4](vec2(0, 0), vec2(0, 1), vec2(1, 1), vec2(1, 0));
    vec2 corner = corners[gl_VertexID % 4];

    vertexDistance = fog_distance(Position, FogShape);
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;

    float centX = ceil(ScrSize.x / 2);

    if (round(Color.rgb * 255) == vec3(128, 255, 32)) //Xp number
    {
        Pos.y += 24.2;

        if (int(ScreenSize.y) % 2 == 0)
            Pos.y += 1;

        Pos.x = centX + corner.x * 8 + gl_VertexID / 4 * 6 + 45;

        vertexColor = vec4(1);
    }
    else if ((Pos.z == 600 || Pos.z == 600.03) && floor(ScrSize.y - Pos.y) < 12) //Count
    {
        float center = centX - 106;
        if (abs(center - Pos.x) <= 9)
        {
            Pos.x -= 72;
        }
        else if (abs(centX + 112 - Pos.x) <= 9)
        {
            Pos.x -= 290;
        }
        else
        {
            for (int i = 0; i < 10; i++)
            {
                center = centX - 77 + i * 20;
                if (abs(center - Pos.x) <= 9)
                {
                    Pos.x += -center + centX - 144 + i * 33 + int(i > 3) * 64;
                    break;
                }
            }
        }
        Pos.y -= 23;
    }
    else if ((Position.z == 400 || Position.z == 400.03) && (abs(ScrSize.y - Pos.y - 58 + corner.y * 8) <= 2 || abs(ScrSize.y - Pos.y - 45 + corner.y * 8) <= 1))
    {
        Pos.y -= 20;
    }

    gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);
}
