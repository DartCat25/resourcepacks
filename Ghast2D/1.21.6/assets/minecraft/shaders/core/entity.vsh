#version 150

#define PI 3.1415926

#moj_import <minecraft:light.glsl>
#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler0;
uniform sampler2D Sampler1;
uniform sampler2D Sampler2;

out float sphericalVertexDistance;
out float cylindricalVertexDistance;
out vec4 vertexColor;
out vec4 lightMapColor;
out vec4 overlayColor;
out vec2 texCoord0;
flat out int custom;

void main() {
    custom = 0;
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
#ifdef NO_CARDINAL_LIGHTING
    vertexColor = Color;
#else
    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color);
#endif
#ifndef EMISSIVE
    lightMapColor = texelFetch(Sampler2, UV2 / 16, 0);
#endif
    overlayColor = texelFetch(Sampler1, UV1, 0);

    texCoord0 = UV0;
#ifdef APPLY_TEXTURE_MATRIX
    texCoord0 = (TextureMat * vec4(UV0, 0.0, 1.0)).xy;
#endif

    vec3 Pos = Position;

    vec2 texSize = textureSize(Sampler0, 0);

    vec2[] corners = vec2[](vec2(0, 0), vec2(0, 1), vec2(1, 1), vec2(1, 0));
    vec2 corner = corners[(gl_VertexID + 3) % 4];

    if (floor(texelFetch(Sampler0, ivec2(0), 0) * 255) == vec4(1, 0, 0, 1)) //Ghast
    {
        custom = 1;
        vec2 uv = UV0 * vec2(64, 32);

        if (gl_VertexID % 60 / 4 == 3 && uv - corner * vec2(16) == vec2(16))
        {
            vec3 norm = normalize(Normal);
            mat3 TBN = mat3(norm.zyx * vec3(-1, 1, 1), vec3(0, 1, 0), norm);

            Pos += vec3((corner.x - 0.5) * 4.5, 0, -2.25) * TBN;
            vec3 dir = normalize(Pos);

            mat2 dirMat = mat2(dir.xz, dir.zx * vec2(1, -1));
            vec2 dr = dirMat * TBN[0].xz;

            float angle = atan(dr.x, -dr.y) / PI / 2 + 0.5;
            float frame = mod(round((angle) * 8), 8);
            bool mirror = false;
            
            if (frame > 4)
            {
                if (frame < 8)
                    mirror = true;
                frame = 3 - frame;
            }
            

            Pos.xz -= (vec3((corner.x - 0.5) * 6.5, 0, 0) * mat3(ModelViewMat)).xz;

            Pos.y -= (corner.y - 0.5) * 3 + 1;
            vertexColor = Color;

            gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);
            texCoord0 = vec2((mirror ? 1/5.0 - corner.x / 5 : corner.x / 5) + frame / 5, corner.y);
        }
        else
            gl_Position = vec4(0);
    }
}
