#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;
uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out float shadow;

void main() {
    
    const vec2[4] corners = vec2[4](vec2(0), vec2(0, 1), vec2(1), vec2(1, 0));
    vec3 Pos = Position;

    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;
    shadow = 0;
    
    float lum = max(Color.r, max(Color.g, Color.b));

    if (Pos.z == 0 && ProjMat[3][0] == -1 && lum > 0.4)
    {
        vec2 corner = corners[gl_VertexID % 4];
        Pos.xy += corner;
        texCoord0 += corner / textureSize(Sampler0, 0);
        shadow = 1;
    }

    gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);
}
