#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler0;
uniform sampler2D Sampler1;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out vec4 vertexColor;
out vec4 lightMapColor;
out vec4 overlayColor;
out vec2 texCoord0;
out vec4 normal;

void main() {
    const vec2[4] corners = vec2[4](vec2(0), vec2(0, 1), vec2(1, 1), vec2(1, 0));
    vec2 ScrSize = ceil(2 / vec2(ProjMat[0][0], -ProjMat[1][1]));
    vec3 Pos = Position;

    texCoord0 = UV0;

    vec4 tex = texture(Sampler0, UV0);

    bool isHeader = abs(Pos.y - ScrSize.y / 2 + 81) <= 1 && int(floor(Pos.x) - floor(ScrSize.x / 2) + 113) % 32 <= 1;

    if (tex.gba == vec3(0, 255, 3) / 255 && ProjMat[3][0] == -1 && abs(ScrSize.y - Pos.y - 12) > 1 && Pos.z == 150)
    {
        switch (int(tex.r * 255))
        {
            case 0: //Story 
                if (abs(floor(Pos.x) - floor(ScrSize.x / 2) + 46) > 1 && abs(floor(Pos.y) - floor(ScrSize.y / 2) + 19) > 1 && !isHeader)
                {
                    Pos.xy += (corners[gl_VertexID % 4] * 256 - vec2(16, 126));
                }
            break;
            case 1: //Nether
                if (!isHeader)
                    Pos.xy += corners[gl_VertexID % 4] * 256 - vec2(16, 121);
            break;
            case 2: //Husbandry (upper part)
                if (!isHeader)
                    Pos.xy += corners[gl_VertexID % 4] * 256 - vec2(64, 154);
            break;
            case 3: //Husbandry (bottome part)
                if (!isHeader)
                    Pos.xy += corners[gl_VertexID % 4] * vec2(256, 64) - vec2(64, 154 - 256);
            break;
            case 4: //End
                if (!isHeader)
                    Pos.xy += corners[gl_VertexID % 4] * 256 - vec2(64, 149);
            break;
            case 5: //Adventure (bottom part)
                Pos.xy += corners[gl_VertexID % 4] * 256 - vec2(104, -162);
            break;
            case 6: //Adventure (upper part)
                Pos.xy += corners[gl_VertexID % 4] * 256 - vec2(104, 94);
            break;
        }

        Pos.z -= 150;
        vec2 texSize = textureSize(Sampler0, 0);
        texCoord0 = round(UV0 * texSize) / texSize;
    }

    gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);

    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color);
    lightMapColor = texelFetch(Sampler2, UV2 / 16, 0);
    overlayColor = texelFetch(Sampler1, UV1, 0);
    
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
