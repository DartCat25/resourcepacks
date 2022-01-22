#version 150

#define NEW_FOG

#ifdef NEW_FOG
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
uniform mat3 IViewRotMat;

uniform vec3 ChunkOffset;

uniform vec4 FogColor;
out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec4 normal;
out vec3 pos;

void main() {
    //vec2 texSize = textureSize(Sampler0, 0);
    vec3 Pos = Position + ChunkOffset;

    gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);

    #ifdef NEW_FOG
        vertexDistance = cylindrical_distance(ModelViewMat, IViewRotMat * Position);
    #else
        vertexDistance = length((ModelViewMat * vec4(Pos + vec3(0, 0.5, 0), 1.0)).xyz);
    #endif

    vertexColor = Color * minecraft_sample_lightmap(Sampler2, UV2);
    texCoord0 = UV0;
    pos = Pos;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
