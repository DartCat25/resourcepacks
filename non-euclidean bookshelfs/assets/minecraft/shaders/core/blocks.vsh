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

out float notEuclid;
out vec3 pos;
flat out vec3 v1, v2, v3;

void main() {
    pos = Position + ChunkOffset;
    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);

    vec4 color = Color;

    notEuclid = 0;
    v1 = v2 = v3 = vec3(0);

    ivec2 uv = ivec2(UV0 * textureSize(Sampler0, 0));
    float alpha = floor(texelFetch(Sampler0, uv, 0).a * 255);


    if (alpha >= 240 && alpha <= 243)
    {
        notEuclid = 1;
        vec3 block = floor(Position);

        if (alpha == 240) //North
        {
            v1 = block + ChunkOffset;
            v2 = block + vec3(0, 1, 0) + ChunkOffset;
            v3 = block + vec3(1, 0, 0) + ChunkOffset;

            if (Normal != vec3(0, 0, -1))
                color.rgb *= color.r - Normal.y * 0.25 < 0.5 ? 1.2 : 0.6;
        }
        else if (alpha == 241) //East
        {
            block.x += 1;
            v1 = block + ChunkOffset;
            v2 = block + vec3(0, 1, 0) + ChunkOffset;
            v3 = block + vec3(0, 0, 1) + ChunkOffset;

            if (Normal != vec3(1, 0, 0 ))
                color.rgb *= color.r - Normal.y * 0.25 < 0.5 ? 1.2 : 0.6;
        }
        else if (alpha == 242) //South
        {
            block.z += 1;
            v1 = block + ChunkOffset;
            v2 = block + vec3(0, 1, 0) + ChunkOffset;
            v3 = block + vec3(1, 0, 0) + ChunkOffset;

            if (Normal != vec3(0, 0, 1 ))
                color.rgb *= color.r - Normal.y * 0.25 < 0.5 ? 1.2 : 0.6;

        }
        else if (alpha == 243) //West
        {
            v1 = block + ChunkOffset;
            v2 = block + vec3(0, 1, 0) + ChunkOffset;
            v3 = block + vec3(0, 0, 1) + ChunkOffset;

            if (Normal != vec3(-1, 0, 0))
                color.rgb *= color.r - Normal.y * 0.25 < 0.5 ? 1.2 : 0.6;
        }
    }

    vertexDistance = fog_distance(ModelViewMat, pos, FogShape);
    vertexColor = color * minecraft_sample_lightmap(Sampler2, UV2);
    texCoord0 = UV0;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
