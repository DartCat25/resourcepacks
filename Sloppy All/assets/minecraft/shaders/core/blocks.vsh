#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec3 ChunkOffset;
uniform int FogShape;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec4 normal;

void main() {
    vec3 Pos = Position;

    vertexColor = Color * minecraft_sample_lightmap(Sampler2, UV2);
    texCoord0 = UV0;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);

    const vec2[4] corners = vec2[4](vec2(0), vec2(0, 1), vec2(1, 1), vec2(1, 0));
    vec2 corner = corners[gl_VertexID % 4];

    float testAlpha = texture(Sampler0, UV0).a * 255;
    vec3 act = fract(Position);

    if ((testAlpha == 252 || testAlpha == 253) && Normal.y > 0 && act.y > 0.01)
    {
        float light = 1;
        float power = 2;

        float col = Color.r * light;

        float offset = clamp((1 - col) * power, 0, ceil(Position.y) - Position.y);

        if (testAlpha == 253)
        {
            float elevation = 1 - offset - fract(Position.y);
            texCoord0.y -= elevation * 16 / textureSize(Sampler0, 0).y;
        }

        Pos += vec3(0, 1, 0) * offset;
    }
    else if (testAlpha == 250)
    {
        Pos.y = floor(Pos.y);
    }
    else if (Normal.y > 0 && act.y > 0 && act.y < 0.01)
    {
        float light = 1;
        float power = 4;

        float col = Color.g;
        if (Color.g != Color.r)
            col *= 1.4;

        float offset = clamp((1 - col) * power, 0, ceil(Position.y) - Position.y);
            
        if (act.x != 0 && act.z == 0)
        {
            vertexColor *= 153.0 / 225.0;
            if (act.x < 0.5 && corner.x == 0)
                offset = 0;
            else if (act.x > 0.5 && corner.x == 1)
                offset = 0;
            else
            {
                float elevation = 1 - offset - fract(Position.y);
                texCoord0.y += elevation * 16 / textureSize(Sampler0, 0).y;
            }
        }
        else if (act.x == 0 && act.z != 0)
        {
            vertexColor *= 204.0 / 225.0;
            if (act.z < 0.5 && corner.y == 0)
                offset = 0;
            else if (act.z > 0.5 && corner.y == 1)
                offset = 0;
            else
            {
                float elevation = 1 - offset - fract(Position.y);
                texCoord0.y += elevation * 16 / textureSize(Sampler0, 0).y;
            }
        }

        Pos = round(Pos);

        Pos += vec3(0, 1, 0) * offset;
    }

    gl_Position = ProjMat * ModelViewMat * vec4(Pos + ChunkOffset, 1.0);

    vertexDistance = fog_distance(ModelViewMat, Pos + ChunkOffset, FogShape);
}
