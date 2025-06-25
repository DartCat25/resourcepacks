#version 150

in vec3 Position;
in vec2 UV0;
in vec4 Color;

uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out vec4 vertexColor;
out vec2 texCoord0;
out vec2 helpCoord;
out vec2 p1, p2;
flat out int type, num;
flat out vec4 tint;
flat out int bilinear;

#define TID(R, G, B) colID == R * 0x10000 + G * 0x100 + B
void main() {
    vertexColor = Color;
    texCoord0 = UV0;
    bilinear = 0;

    type = num = 0;
    p1 = p2 = vec2(0);

    ivec2 texSize = textureSize(Sampler0, 0);
    vec2 uv = floor(UV0 * texSize);

    //Base parameters
    int id = (gl_VertexID) % 4;
    const vec2[4] corners = vec2[4](vec2(0, 0), vec2(0, 1), vec2(1, 1), vec2(1, 0));
    vec2 corner = corners[id];
    helpCoord = 1-corner;
    vec3 Pos = Position;
    vec2 ScrSize = 2 / vec2(ProjMat[0][0], -ProjMat[1][1]);
    
    ivec4 testColor = ivec4(floor(texelFetch(Sampler0, ivec2(uv - corner), 0) * 255));
    int colID = testColor.r * 0x10000 + testColor.g * 0x100 + testColor.b;

    if (testColor.a == 255 && ProjMat[3][0] == -1)
    {
        // //Icons
        if (TID(2, 0, 1) || TID(2, 1, 1) || TID(2, 1, 2)) //Hearts
        {
            bilinear = 1;
            int slotID = int(Pos.x - ScrSize.x / 2 + 96 - corner.x * 9) / 8;
            int strID = int(ScrSize.y - Pos.y - 37) + int(corner.y) * 9;
            
            if (TID(2, 0, 1)) //Slot Base
            {
                type = 1;
                Pos.xy = vec2(ScrSize.x / 2 - 31, ScrSize.y - 90) + corner * vec2(310, 271) * 0.2;
                uv = vec2(0, 211) + corner * vec2(310, 271);
                num = slotID * 2 + strID / 8 * 20;
            }
            else //Hp
            {
                type = 2;
                tint = texelFetch(Sampler0, ivec2(uv - corner * 9 + 3), 0);
                num = slotID * 2 + 2 - int(TID(2, 1, 2)) + strID / 9 * 20;
                Pos.xy = vec2(ScrSize.x / 2 - 25.7, ScrSize.y - 82) + corner * vec2(257, 202) * 0.2;
                uv = vec2(310, 211) + corner * vec2(257, 202);
            }

            Pos.y += 24;
        }
        else if (TID(1, 0, 4) || TID(1, 1, 2) || TID(1, 1, 3)) //Food
        {
            int slotID = 9 - int(Pos.x - ScrSize.x / 2 - 6 - corner.x * 9) / 8;

            if (TID(1, 0, 4)) //Slot Base
            {
                Pos.xy = vec2(ScrSize.x / 2 - 32 - 22, ScrSize.y - 20) + corner * vec2(98, 18);
                uv = vec2(707, 221) + corner * vec2(98, 18);
            }
            else
            {
                type = 4;
                tint = texelFetch(Sampler0, ivec2(uv - corner * 4 + 1), 0);
                num = slotID * 2 + 2 - int(TID(1, 1, 2));
                Pos.xy = vec2(ScrSize.x / 2 + 2, ScrSize.y - 10) + corner * vec2(13, 7);
                uv = vec2(670, 234) + corner * vec2(13, 7);
                Pos.z += slotID * 2;
            }
        }
        else if (TID(1, 3, 2) || TID(1, 3, 3)) //Armor
        {
            int slotID = int(Pos.x - ScrSize.x / 2 + 96 - corner.x * 9) / 8;
            if (uv.x - corner.x * 9 != 16)
            {
                type = 5;
                tint = vec4(200, 200, 200, 255) / 255;
                num = slotID * 2 + 2 - int(TID(1, 3, 2));
                Pos.xy = vec2(ScrSize.x / 2 - 33, ScrSize.y - 10) + corner * vec2(31, 7);
                uv = vec2(670, 241) + corner * vec2(31, 7);
                Pos.z += slotID * 0.002;
                
            }
            else
            {
                Pos = vec3(0);
            }
        }
        else if (TID(2, 0, 2) || TID(2, 2, 1) || TID(2, 2, 2)) //Horse hearts
        {
            int slotID = 9 - int(Pos.x - ScrSize.x / 2 - 6) / 8 + int(id > 1);
            int strID = int(ScrSize.y - Pos.y - 36.5) + int(id == 1 || id == 2) * 9;

            int line23 = int(strID / 8 > 0);
            int line3 = int(strID / 8 > 1);

            if (TID(2, 0, 2)) //Slot Base
            {
                if (slotID == 0 && line23 == 0)
                {
                    Pos.xy = vec2(ScrSize.x / 2 - 32, ScrSize.y - 20) + corner * vec2(98, 18);
                    uv = vec2(729, 239) + corner * vec2(98, 18);
                }
                else
                {
                    type = 3;
                    tint = vec4(239, 126, 74, 255) / 255;
                    num = slotID * 2 + 2 + line23 * 20 + line3 * 20;
                    Pos.xy = vec2(ScrSize.x / 2 + 21, ScrSize.y - 10) + corner * vec2(11, 7);
                    uv = vec2(689, 234) + corner * vec2(11, 7);
                    Pos.z += slotID * 0.002 + line23 * 0.002 + line3 * 0.002;
                }
            }
            else
            {
                type = 4;
                tint = vec4(239, 126, 74, 255) / 255;
                num = slotID * 2 + 2 - int(TID(2, 2, 2)) + line23 * 20 + line3 * 20;
                Pos.xy = vec2(ScrSize.x / 2 + 2, ScrSize.y - 10) + corner * vec2(13, 7);
                uv = vec2(670, 234) + corner * vec2(13, 7);
            }
        }
        else if (TID(1, 4, 1)) //Air
        {
            int slotID = 9 - int(Pos.x - ScrSize.x / 2 - 6 - corner.x * 9) / 8;
            Pos.xy = vec2(ScrSize.x / 2 - 66 - slotID * 10, ScrSize.y - 7.5) + corner * vec2(10, 2);
            uv = vec2(676, 266) + corner;
        }
        else if (TID(2, 3, 1)) //Xp
        {
            type = 7;
            if (gl_VertexID % 4 == 0)
                p1 = vec2(Pos.x, 1);
            else if (gl_VertexID % 4 == 2)
                p2 = vec2(Pos.x, 1);
            Pos.xy = vec2(ScrSize.x / 2 + 69.5 + 100 * corner.x, ScrSize.y - 7.5 + corner.y * 2);
            uv = vec2(682.001, 262) + corner * vec2(100, 2);
            //Pos.z += 10;
        }
        else if (TID(2, 3, 2)) //Horse jump
        {
            type = 7;
            if (gl_VertexID % 4 == 0)
                p1 = vec2(Pos.x, 1);
            else if (gl_VertexID % 4 == 2)
                p2 = vec2(Pos.x, 1);
            Pos.xy = vec2(ScrSize.x / 2 + 69.5 + 100 * corner.x, ScrSize.y - 7.5 + corner.y * 2);
            uv = vec2(682.001, 266) + corner * vec2(100, 2);
        }

        // //Widgets
        else if (TID(1, 0, 1)) //Hotbar
        {
            bilinear = 1;
            Pos.xy = vec2(ScrSize.x / 2 - 1636 / 8, ScrSize.y - 210/4) + corner * vec2(1634, 210) / 4;
            uv = vec2(0, 0) + corner * vec2(1636, 210);
        }
        else if (TID(1, 0, 2)) //Selected Item
        {
            uv = vec2(567, 211) + corner * vec2(103);
            int slot = int((Pos.x - corner.x * 24 - ScrSize.x / 2 + 93) / 20);

            Pos.xy = vec2(ScrSize.x / 2 - 160 + slot * 32.95 + int(slot > 3) * 64, ScrSize.y - 46) + corner * 25;
        }

    
        texCoord0 = uv / texSize;
    }

    gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);
}
