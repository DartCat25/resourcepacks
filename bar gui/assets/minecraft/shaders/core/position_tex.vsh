#version 150

in vec3 Position;
in vec2 UV0;

uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec2 ScreenSize;

out vec2 texCoord0;


void main() {
    texCoord0 = UV0;
    
    vec4 testColor = floor(texelFetch(Sampler0, ivec2(255), 0) * 255);

    const vec2[4] corners = vec2[4](vec2(0, 0), vec2(0, 1), vec2(1, 1), vec2(1, 0));
    int id = (gl_VertexID) % 4;
    vec2 corner = corners[id];

    ivec2 texSize = textureSize(Sampler0, 0);
    vec2 uv = floor(UV0 * 256);
    vec3 Pos = Position;
    vec2 ScrSize = 2 / vec2(ProjMat[0][0], -ProjMat[1][1]);

    if (testColor == vec4(255, 0, 0, 255)) // // Icons
    {
        if (uv.x >= 16 &&
            (
                (uv.y - corner.y * 9 == 0) ||
                (uv.x - corner.x * 9 <= 43 && uv.y - corner.y * 9 == 9) ||
                (uv.y - corner.y * 9 == 45)
            )
        ) // Hearts, Armor, Hardcore Hearts and Rock'n'roll
        {
            int slotID = int(Pos.x - ScrSize.x / 2 + 92) / 8 - int(corner.x);
            //int YPos = int(ScrSize.y - Pos.y + corner.y * 9 + 2) / 5 * 5 + 2;
            //Pos.y = float(ScrSize.y - YPos + corner.y * 9);
            

            if (slotID == 0)
                texCoord0.y += 112/256.0;

            Pos.z += slotID * 10;
        }
        else if (uv.x >= 16 &&
            (
                (uv.y - corner.y * 9 == 27) ||
                (uv.x - corner.x * 9 > 43 && uv.y - corner.y * 9 == 9) ||
                (uv.y - corner.y * 9 == 18)
            )
        ) // Hunger, Horse Hearts, Air and two barrels
        {
            int slotID = int(Pos.x - ScrSize.x / 2 - 8) / 8 - int(corner.x);
            Pos.y = float(int(Pos.y - corner.y * 9 + 2) / 5 * 5 + corner.y * 9) - 1;
            

            if (slotID == 9)
            {
                texCoord0.y += 112/256.0;
                if (uv.y - corner.y * 9 == 18)
                {
                    if (corner.x == 1)
                        texCoord0.x += 72 / 256.0;
                    else
                        Pos.x -= 72;
                    if (uv.x - corner.x * 9 == 25)
                        texCoord0.x += 73 / 256.0;
                }
            }

            //Pos.z += slotID * 10;
        }
    }

    gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);
}
