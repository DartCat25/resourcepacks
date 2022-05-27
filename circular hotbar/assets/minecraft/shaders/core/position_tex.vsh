#version 150

#moj_import <config.glsl>

#if HORISONTAL == 0
    #define FLIPX 1
#else
    #define FLIPX -1
#endif

#define PI 3.1415926

in vec3 Position;
in vec2 UV0;

uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec2 ScreenSize;

out vec2 texCoord0;
out vec2 helpCoord;
out float xp;

void main() {
    texCoord0 = UV0;

    helpCoord = vec2(0);
    xp = 0;

    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    
    ivec2 texSize = textureSize(Sampler0, 0);
    vec2 uv = floor(UV0 * 256);

    mat4 testMat = ProjMat;

    if (!(texelFetch(Sampler0, ivec2(0, 228 / 256.0 * texSize.y), 0) == vec4(1))) //Stop shader, if it isn't icon texture
        return;

    //Base parameters
    const vec2[4] corners = vec2[4](vec2(0, 0), vec2(0, 1), vec2(1, 1), vec2(1, 0));
    vec3 Pos = Position;
    vec2 ScrSize = 2 / vec2(ProjMat[0][0], -ProjMat[1][1]);
    int id = (gl_VertexID + 1) % 4;

    vec2 offset = vec2(55, ScrSize.y - 64);

    #if HORISONTAL == 1
        offset.x = ScrSize.x - 65;
    #endif
    #if VERTICAL == 1
        offset.y = 56;
    #endif

    if (uv.x >= 16 && uv.x <= 196 && (uv.y - corners[id].y * 9 == 0 || uv.y - corners[id].y * 9 == 45)) //Hearts
    {
        int heartID = int(Pos.x - ScrSize.x / 2 + 96) / 8 - int(id > 1);
        int strID = int(ScrSize.y - Pos.y - 37) + int(id == 1 || id == 2) * 8;

        int tooBig = int(strID >= 9);
        if (tooBig != 0) strID += int(id == 1 || id == 2);

        float circPos = ((9 - heartID) / 10.0 + 0.4) * PI;
        if (tooBig != 0) circPos = circPos / int(strID / 9) + PI * (strID / 150.0 - 0.1);
        float r = 32 + strID + tooBig * 17;

        //Flip only hearts out of circle
        #if VERTICAL == 0
            int flipYBig = 1;
        #else
            int flipYBig = tooBig * -2 + 1;
        #endif

        Pos.xy = round(offset + vec2(sin(circPos) * FLIPX, cos(circPos) * flipYBig) * r + corners[id] * 9);
    }
    else if (uv.x >= 16 && uv.x <= 142 && uv.y - corners[id].y * 9 == 27) //Food
    {
        int foodID = int(Pos.x - ScrSize.x / 2 - 6) / 8 - int(id > 1);
        int strID = int(ScrSize.y - Pos.y - 37) + int(id == 1 || id == 2) * 8;
        float circPos = (foodID / 10.0 + 1.4) * PI;
        float r = 32 + strID / 2;
        Pos.xy = round(offset + vec2(sin(circPos) * FLIPX, cos(circPos)) * r + corners[id] * 9);       
    }
    else if (uv.x >= 16 && uv.x - corners[id].x * 9 <= 43 && uv.y - corners[id].y * 9 == 9) //Armor
    {
        int armorID = int(Pos.x - ScrSize.x / 2 + 96) / 8 - int(id > 1);
        float circPos = ((9 - armorID) / 10.0 + 0.4) * PI;

        Pos.xy = round(offset + vec2(sin(circPos) * FLIPX, cos(circPos)) * 43 + corners[id] * 9);
    }
    else if (uv.x >= 16 && uv.x - corners[id].x * 9 >= 43 && uv.y - corners[id].y * 9 == 9) //Horse hearts
    {
        int heartID = int(Pos.x - ScrSize.x / 2 - 6) / 8 - int(id > 1);
        int strID = int(ScrSize.y - Pos.y - 36.5) + int(id == 1 || id == 2) * 9;

        float line23 = float(strID / 8 > 0);
        float line3 = float(strID / 8 > 1);

        float circPos = (heartID / 10.0 / (line23 + 1) + 1.4 + line23 * 0.4725 - line3 * 0.5) * PI;
        float r = 32 + strID / 9 * 9 + line23 - line3 * 10;
        Pos.xy = round(offset + vec2(sin(circPos) * FLIPX, cos(circPos)) * r + corners[id] * 9);
    }
    else if (uv.x >= 16 && uv.x - 9 + corners[id].x * 9 <= 52 && uv.y - corners[id].y * 9 == 18) //Air
    {
        int bubbleID = int(Pos.x - ScrSize.x / 2 - 6) / 8 - int(id > 1);
        float circPos = (bubbleID / 10.0 + 1.4) * PI;

        Pos.xy = offset + vec2(sin(circPos) * FLIPX, cos(circPos)) * 42 + corners[id] * 9;        
    }
    else if (uv.x <= 182 && ((uv.y >= 64 && uv.y <= 74) || (uv.y >= 84 && uv.y <= 94))) //Xp and horse's jump Bars
    {
        Pos.xy = offset + corners[id] * 110 - vec2(50, 51);
        helpCoord = corners[id] * 2 - 1;
        xp = uv.x / 182.0;
        if (id > 1)
            uv.x = 182;
    }

    texCoord0 = uv / 256;
    gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);
}
