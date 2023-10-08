#version 150

in vec3 Position;
in vec2 UV0;

uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec2 ScreenSize;

out vec2 texCoord0;
out vec2 helpCoord;
flat out int type, num;
flat out vec4 tint;
flat out int bilinear;

void main() {
    texCoord0 = UV0;
    bilinear = 0;

    type = num = 0;

    ivec2 texSize = textureSize(Sampler0, 0);
    vec2 uv = floor(UV0 * 256);

    //Base parameters
    int id = (gl_VertexID) % 4;
    const vec2[4] corners = vec2[4](vec2(0, 0), vec2(0, 1), vec2(1, 1), vec2(1, 0));
    vec2 corner = corners[id];
    helpCoord = 1-corner;
    vec3 Pos = Position;
    vec2 ScrSize = 2 / vec2(ProjMat[0][0], -ProjMat[1][1]);
    
    if ((texelFetch(Sampler0, ivec2(0, 228), 0) == vec4(1))) //Icons
    {
        if (uv.x >= 16 && uv.x <= 196 && (uv.y - corner.y * 9 == 0 || uv.y - corner.y * 9 == 45)) //Hearts
        {
            bilinear = 1;
            int slotID = int(Pos.x - ScrSize.x / 2 + 96 - corner.x * 9) / 8;
            int strID = int(ScrSize.y - Pos.y - 37) + int(corner.y) * 9;
            
            if (uv.x - corner.x < 52) //Slot Base
            {
                type = 1;
                Pos.xy = vec2(ScrSize.x / 2 - 31, ScrSize.y - 90) + corner * vec2(310, 278) * 0.2;
                uv = vec2(0, 234) + corner * vec2(310, 278);
                num = slotID * 2 + strID / 8 * 20;
            }
            else //Hp
            {
                type = 2;
                tint = texelFetch(Sampler0, ivec2(int(uv.x - corner.x * 9) + 3, 4), 0);
                num = slotID * 2 + 2 - int((int(uv.x - 52 - corner.x * 9) / 9) % 2 == 1) + strID / 9 * 20;
                Pos.xy = vec2(ScrSize.x / 2 - 25.7, ScrSize.y - 82) + corner * vec2(257, 202) * 0.2;
                uv = vec2(255, 0) + corner * vec2(257, 202);
            }

            Pos.y += 24;
            
        }
        else if (uv.x >= 16 && uv.x <= 142 && uv.y - corner.y * 9 == 27) //Food
        {
            int slotID = 9 - int(Pos.x - ScrSize.x / 2 - 6 - corner.x * 9) / 8;

            if (uv.x - corner.x < 52 || uv.x - corner.x >= 124) //Slot Base
            {
                Pos.xy = vec2(ScrSize.x / 2 - 32 - 22, ScrSize.y - 20) + corner * vec2(98, 18);
                uv = vec2(37, 122) + corner * vec2(98, 18);
            }
            else
            {
                type = 4;
                tint = texelFetch(Sampler0, ivec2(int(uv.x - corner.x * 9) + 5, 31), 0);
                num = slotID * 2 + 2 - int((int(uv.x - 52 - corner.x * 9) / 9) % 2 == 1);
                Pos.xy = vec2(ScrSize.x / 2 + 2, ScrSize.y - 10) + corner * vec2(13, 7);
                uv = vec2(0, 135) + corner * vec2(13, 7);
                Pos.z += slotID * 2;
            }
        }
        else if (uv.x >= 16 && uv.x - corner.x * 9 <= 43 && uv.y - corner.y * 9 == 9) //Armor
        {
            int slotID = int(Pos.x - ScrSize.x / 2 + 96 - corner.x * 9) / 8;
            if (uv.x - corner.x * 9 != 16)
            {
                type = 5;
                tint = vec4(200, 200, 200, 255) / 255;
                num = slotID * 2 + 2 - int(uv.x - corner.x * 9 <= 25);
                Pos.xy = vec2(ScrSize.x / 2 - 33, ScrSize.y - 10) + corner * vec2(31, 7);
                uv = vec2(0, 142) + corner * vec2(31, 7);
                Pos.z += slotID * 0.002;
            }
            else
            {
                Pos = vec3(0);
            }
        }
        else if (uv.x >= 16 && uv.x - corner.x * 9 >= 43 && uv.y - corner.y * 9 == 9) //Horse hearts
        {
            int slotID = 9 - int(Pos.x - ScrSize.x / 2 - 6) / 8 + int(id > 1);
            int strID = int(ScrSize.y - Pos.y - 36.5) + int(id == 1 || id == 2) * 9;

            int line23 = int(strID / 8 > 0);
            int line3 = int(strID / 8 > 1);

            if (uv.x - corner.x < 88) //Slot Base
            {
                if (slotID == 0 && line23 == 0)
                {
                    Pos.xy = vec2(ScrSize.x / 2 - 32, ScrSize.y - 20) + corner * vec2(98, 18);
                    uv = vec2(37 + 22, 140) + corner * vec2(98, 18);
                }
                else
                {
                    type = 3;
                    tint = vec4(239, 126, 74, 255) / 255;
                    num = slotID * 2 + 2 + line23 * 20 + line3 * 20;
                    Pos.xy = vec2(ScrSize.x / 2 + 21, ScrSize.y - 10) + corner * vec2(11, 7);
                    uv = vec2(19, 135) + corner * vec2(11, 7);
                    Pos.z += slotID * 0.002 + line23 * 0.002 + line3 * 0.002;
                }
            }
            else
            {
                type = 4;
                tint = vec4(239, 126, 74, 255) / 255;
                num = slotID * 2 + 2 - int((int(uv.x - 52 - corner.x * 9) / 9) % 2 == 1) + line23 * 20 + line3 * 20;
                Pos.xy = vec2(ScrSize.x / 2 + 2, ScrSize.y - 10) + corner * vec2(13, 7);
                uv = vec2(0, 135) + corner * vec2(13, 7);
            }
        }
        else if (uv.x >= 16 && uv.x - 9 + corner.x * 9 <= 52 && uv.y - corner.y * 9 == 18) //Air
        {
            int slotID = 9 - int(Pos.x - ScrSize.x / 2 - 6 - corner.x * 9) / 8;
            Pos.xy = vec2(ScrSize.x / 2 - 66 - slotID * 10, ScrSize.y - 8) + corner * vec2(10, 2);
            uv = vec2(6, 167) + corner;
        }
        else if (uv.y - corner.y * 5 == 69) //Xp
        {
            Pos.xy = vec2(ScrSize.x / 2 + 70 + uv.x / 182 * 100, ScrSize.y - 8 + corner.y * 2);
            uv = vec2(12, 163) + corner * vec2(uv.x / 182 * 100, 2);
        }
        else if (uv.y - corner.y * 5 == 89) //Horse jump
        {
            Pos.xy = vec2(ScrSize.x / 2 + 70 + uv.x / 182 * 100, ScrSize.y - 8 + corner.y * 2);
            uv = vec2(12, 167) + corner * vec2(uv.x / 182 * 100, 2);
        }

        texCoord0 = uv / 512;
    }
    else if ((texelFetch(Sampler0, ivec2(0, 255), 0) == vec4(1, 0, 0, 1))) //Widgets
    {
        if (uv - corner * vec2(182, 22) == vec2(0)) //Hotbar
        {
            bilinear = 1;
            Pos.xy = vec2(ScrSize.x / 2 - 1636 / 8, ScrSize.y - 210/4) + corner * vec2(1636, 210) / 4;
            uv = vec2(200, 46) + corner * vec2(1636, 210);
        }
        else if (uv - corner * vec2(24, 22) == vec2(0, 22)) //Selected Item
        {
            uv = vec2(97, 153) + corner * vec2(103);
            int slot = int((Pos.x - corner.x * 24 - ScrSize.x / 2 + 93) / 20);

            Pos.xy = vec2(ScrSize.x / 2 - 160 + slot * 33 + int(slot > 3) * 64, ScrSize.y - 46) + corner * 25;
        }

        texCoord0 = uv / vec2(1836, 256);
    }

    gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);
}
