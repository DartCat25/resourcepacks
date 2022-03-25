#version 150

#define VERSION 0 //0 - 1.17-1.18; 1 - 1.18.1; 2 - 1.18.2;

#if VERSION != 0
    #moj_import <fog.glsl>
#endif

#moj_import <light.glsl>

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

uniform vec4 FogColor;
uniform int FogShape;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec4 normal;
out vec3 pos;

void main() {
    //vec2 texSize = textureSize(Sampler0, 0);
    vec3 Pos = Position + ChunkOffset;

    gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);

    #if VERSION == 2
        vertexDistance = fog_distance(ModelViewMat, pos, FogShape);
    #elif VERSION == 1
        vertexDistance = cylindrical_distance(ModelViewMat, Pos);
    #else
        vertexDistance = length((ModelViewMat * vec4(Pos, 1.0)).xyz);
    #endif

    vertexColor = Color * minecraft_sample_lightmap(Sampler2, UV2);
    texCoord0 = UV0;
    pos = Pos;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
