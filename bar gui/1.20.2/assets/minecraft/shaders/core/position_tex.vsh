#version 150

in vec3 Position;
in vec2 UV0;

uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out vec2 texCoord0;

#define TID(R, G, B, A) colID == A * 0x1000000 + R * 0x10000 + G * 0x100 + B
void main() {
    texCoord0 = UV0;

    const vec2[4] corners = vec2[4](vec2(0, 0), vec2(0, 1), vec2(1, 1), vec2(1, 0));
    int id = (gl_VertexID) % 4;
    vec2 corner = corners[id];

    ivec2 texSize = textureSize(Sampler0, 0);
    vec2 uv = floor(UV0 * texSize);
    vec3 Pos = Position;
    vec2 ScrSize = 2 / vec2(ProjMat[0][0], -ProjMat[1][1]);

    ivec4 testColor = ivec4(floor(texelFetch(Sampler0, ivec2(uv - corner), 0) * 255));
    int colID = testColor.a * 0x1000000 + testColor.r * 0x10000 + testColor.g * 0x100 + testColor.b;

    if (TID(1, 0, 0, 1)) // Hearts, Armor, Hardcore Hearts and Rock'n'roll
    {
        int slotID = int(Pos.x - ScrSize.x / 2 + 92) / 8 - int(corner.x);
        //int YPos = int(ScrSize.y - Pos.y + corner.y * 9 + 2) / 5 * 5 + 2;
        //Pos.y = float(ScrSize.y - YPos + corner.y * 9);

        uv -= corner * 2 - 1;
        uv.x -= corner.x * 9;

        if (slotID != 0)
            uv.x += 9;

        //Pos.y -= slotID * 9;

        Pos.z += slotID * 10;

        texCoord0 = uv / texSize;
    }
    else if (TID(2, 0, 0, 1)) // Hunger, Horse Hearts and two barrels
    {
        int slotID = int(Pos.x - ScrSize.x / 2 - 8) / 8 - int(corner.x);
        Pos.y = float(int(Pos.y - corner.y * 9 + 2) / 5 * 5 + corner.y * 9) - 1;
        
        uv -= corner * 2 - 1;
        uv.x -= corner.x * 9;

        if (slotID == 9)
        {
            uv.x += 9;
        }

        texCoord0 = uv / texSize;
    }
    else if (TID(3, 0, 0, 255)) // Air
    {
        int slotID = int(Pos.x - ScrSize.x / 2 - 8) / 8 - int(corner.x);
        Pos.y = float(int(Pos.y - corner.y * 9 + 2) / 5 * 5 + corner.y * 9) - 1;
        
        uv -= corner * 2 - 1;
        uv.x -= corner.x * 81;

        if (slotID == 9)
        {
            uv.x += 9 + corner.x * 72;
            Pos.x -= 72 * (1 - corner.x);
        }

        texCoord0 = uv / texSize;
    }

    gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);
}
