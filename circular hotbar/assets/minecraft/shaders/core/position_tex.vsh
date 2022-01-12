#version 150

#define PI 3.1415926

in vec3 Position;
in vec2 UV0;

uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec2 ScreenSize;

uniform float GameTime;

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
    int Scale = int(ScreenSize.x * ProjMat[0][0] / 2);
    vec2 ScrSize = ScreenSize / Scale;
    int id = (gl_VertexID + 1) % 4;
    vec2 offset = vec2(60, ScrSize.y - 60);
    //vec2 offset = ScrSize / 2;

    if (uv.x >= 16 && uv.x <= 196 && uv.y - corners[id].y * 9 == 0) //Hearts
    {
        int heartID = int(Pos.x - ScrSize.x / 2 + 96) / 8 - int(id > 1);
        int strID = int(ScrSize.y - Pos.y - 37) + int(id == 1 || id == 2) * 8;

        int toBig = int(strID >= 9);
        if (toBig != 0) strID += int(id == 1 || id == 2);

        float circPos = ((9 - heartID) / 10.0 + 0.4) * PI;
        if (toBig != 0) circPos = circPos / int(strID / 9) + PI * (strID / 150.0 - 0.1);
        float r = 32 + strID + toBig * 17;
        Pos.xy = offset + vec2(sin(circPos) * r - 5, cos(-circPos) * r - 4) + corners[id] * 9;
    }
    else if (uv.x >= 16 && uv.x <= 142 && uv.y - corners[id].y * 9 == 27) //Food
    {
        int foodID = int(Pos.x - ScrSize.x / 2 - 6) / 8 - int(id > 1);
        int strID = int(ScrSize.y - Pos.y - 37) + int(id == 1 || id == 2) * 8;
        float circPos = (foodID / 10.0 + 1.4) * PI;
        float r = 32 + strID / 2;
        Pos.xy = offset + vec2(sin(circPos) * r - 5, cos(-circPos) * r - 4) + corners[id] * 9;        
    }
    else if (uv.x >= 16 && uv.x - corners[id].x * 9 <= 43 && uv.y - corners[id].y * 9 == 9) //Armor
    {
        int armorID = int(Pos.x - ScrSize.x / 2 + 96) / 8 - int(id > 1);
        float circPos = ((9 - armorID) / 10.0 + 0.4) * PI;
        float r = 43;
        Pos.xy = offset + vec2(sin(circPos) * r - 5, cos(-circPos) * r - 4) + corners[id] * 9;
    }
    else if (uv.x >= 16 && uv.x - 9 + corners[id].x * 9 <= 52 && uv.y - corners[id].y * 9 == 18) //Air
    {
        int bubbleID = int(Pos.x - ScrSize.x / 2 - 6) / 8 - int(id > 1);
        float circPos = (bubbleID / 10.0 + 1.4) * PI;
        float r = 42;
        Pos.xy = offset + vec2(sin(circPos) * r - 5, cos(-circPos) * r - 4) + corners[id] * 9;        
    }
    else if (uv.x <= 182 && uv.y >= 64 && uv.y <= 74) //XP bar
    {
        Pos.xy = offset + corners[id] * 110 - 55;
        helpCoord = corners[id] * 2 - 1;
        xp = uv.x / 182.0;
        if (id > 1)
            uv.x = 182;
    }

    texCoord0 = uv / 256;
    gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);
}
