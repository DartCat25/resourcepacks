#version 150

#moj_import <config.glsl>
#moj_import <light.glsl>
#ifdef NEW_FOG
    #moj_import <fog.glsl>
#endif

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec3 ChunkOffset;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec4 normal;
out vec2 light;
out vec4 Pos;
out vec4 Norm;

void main() {

    vec3 pos = Position + ChunkOffset;

    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);

    light = vec2(UV2) / 16;
    Pos = vec4(Position, 0);
    Norm = vec4(normalize(Normal), 0);


    #ifdef NEW_FOG
        vertexDistance = cylindrical_distance(ModelViewMat, pos);
    #else
        vertexDistance = length((ModelViewMat * vec4(pos, 1.0)).xyz);
    #endif

    vertexColor = Color * minecraft_sample_lightmap(Sampler2, UV2);
    texCoord0 = UV0;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
