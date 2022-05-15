#version 150

//Made by DartCat25
//Thanks to people from ShaderLABS

#define NOTES_COUNT 12

#moj_import <fog.glsl>

in vec3 Position;
in vec2 UV0;
in vec4 Color;
in ivec2 UV2;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;

out float vertexDistance;
out vec2 texCoord0;
out vec4 vertexColor;

out vec4 Pos;
out vec4 glPos;

out vec2 uv1, uv2, inUV;
flat out vec2 uv3;

void main() {
    vertexDistance = fog_distance(ModelViewMat, Position, FogShape);
    texCoord0 = UV0;
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    Pos = vec4(0);

    vec2 texSize = textureSize(Sampler0, 0);
    vec2 uv = (UV0 * texSize);

    if (floor(uv) != uv && texSize.y / texSize.x != 4) //Breaking
    {
        const vec2[4] corners = vec2[4](vec2(0), vec2(0, 1), vec2(1, 1), vec2(1, 0));
        int id = gl_VertexID % 4;
        vec2 inCoords = (corners[id] - 0.5) / 4 * vec2(1, -1);
        
        Pos = vec4(Position + vec3(0, 0.0625, 0), 1);
        glPos = Pos - vec4(inCoords * 1.6, 0, 0) * ModelViewMat;
        gl_Position = ProjMat * (ModelViewMat * Pos - vec4(inCoords, 0, 0)); //Expand Particle

        //UV trick
        uv1 = uv2 = vec2(0);
        if (id == 0) uv1 = uv;
        if (id == 2) uv2 = uv;
        uv3 = inUV = corners[id];

        return;
    }

    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
}
