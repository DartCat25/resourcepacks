#version 150

in vec3 Position;
in vec4 Color;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out vec4 vertexColor;

void main() {
    vec2 ScrSize = 2 / vec2(ProjMat[0][0], -ProjMat[1][1]);
    const vec2[4] corners = vec2[4](vec2(0, 0), vec2(0, 1), vec2(1, 1), vec2(1, 0));
    vec2 corner = corners[gl_VertexID % 4];
    vec3 Pos = Position;

    float elev = round(ScrSize.y) - Pos.y;

    if (Pos.z == 600 && elev <= 6 && elev >= 2 && Color.rgb != vec3(208 / 255.0))
    {
        float center = floor(ScrSize.x / 2) - 108;
        if (abs(center - Pos.x) <= 9)
        {
            Pos.x -= 72;
        }
        else if (abs(floor(ScrSize.x / 2) + 108 - Pos.x) <= 9)
        {
            Pos.x -= 290;
        }
        else
        {
            for (int i = 0; i < 10; i++)
            {
                center = floor(ScrSize.x / 2) - 79 + i * 20;
                if (abs(center - Pos.x) <= 9)
                {
                    Pos.x += -center + floor(ScrSize.x / 2) - 147 + i * 33 + int(i > 3) * 64;
                    break;
                }
            }
        }
        Pos.y -= 23;
    }

    gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);

    vertexColor = Color;
}
