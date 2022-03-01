#version 150

#define VERSION 0 //0 - 1.17-1.18(1.18.1+ with broken fog); 1 - 1.18.1; 2 - 1.18.2(+);

#define NOTES_COUNT 12
#define COLORS_COUNT 25 //Two octaves + F# of third octave;

#if VERSION > 0
    #moj_import <fog.glsl>
#endif

in vec3 Position;
in vec2 UV0;
in vec4 Color;
in ivec2 UV2;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
#if VERSION == 2
    uniform int FogShape;
#endif
out float vertexDistance;
out vec2 texCoord0;
out vec4 vertexColor;

const vec3[COLORS_COUNT] tCol = vec3[COLORS_COUNT](
    //First octave
    vec3(89, 232, 0),
    vec3(132, 206, 0),
    vec3(172, 172, 0),
    vec3(206, 132, 0),
    vec3(232, 89, 0),
    vec3(249, 46, 0),
    vec3(255, 6, 6),
    vec3(249, 0, 46),
    vec3(232, 0, 89),
    vec3(206, 0, 132),
    vec3(172, 0, 172),
    vec3(132, 0, 206),
    //Second octave
    vec3(89, 0, 232),
    vec3(46, 0, 249),
    vec3(6, 6, 255),
    vec3(0, 46, 249),
    vec3(0, 89, 232),
    vec3(0, 132, 206),
    vec3(0, 172, 172),
    vec3(0, 206, 132),
    vec3(0, 232, 89),
    vec3(0, 249, 46),
    vec3(6, 255, 6),
    vec3(46, 249, 0),
    //Third octave
    vec3(89, 232, 0)
);
//Calculation with sequence will be later.

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    #if VERSION == 0
        vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
    #elif VERSION == 1
        vertexDistance = cylindrical_distance(ModelViewMat, Position);
    #else
        vertexDistance = fog_distance(ModelViewMat, Position, FogShape);
    #endif
    texCoord0 = UV0;
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);

    vec2 texSize = textureSize(Sampler0, 0);
    vec2 uv = floor(UV0 * texSize);

    const vec2[4] corners = vec2[4](vec2(1, 1), vec2(1, 0), vec2(0), vec2(0, 1));
    vec2 corner = corners[gl_VertexID % 4];

    vec4 testColor = floor(texelFetch(Sampler0, ivec2(uv - corner), 0) * 255);
    
    if (testColor == vec4(0, 0, 255, 0) && Color != vec4(1)) //Note
    {
        uv -= vec2(48, 32) * corner;
        
        vec3 compCol = floor(Color.rgb * 255);
        for (int i = 0; i < COLORS_COUNT; i++)
        {
            vec3 dif = abs(compCol - tCol[i]);
            if (dif.r + dif.g + dif.b < 50)
            {
                int id = (i + 6) % NOTES_COUNT;
                uv += vec2(id % 4, id / 4 % 3) * 16;
                break;
            }
        }
        gl_Position += vec4((corner * 2 - 1), 1, 0) * vec4(0.1, -0.1, 0, 0) * ProjMat; //Expand Note
        texCoord0 = uv / texSize;
    }

    
}
