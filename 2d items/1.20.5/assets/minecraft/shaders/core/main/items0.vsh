#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>
#define NO_LIGHTMAP
#define PI 3.14159265

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
uniform float FogStart;
uniform int FogShape;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out vec4 vertexColor;
out vec4 lightMapColor;
out vec4 overlayColor;
out vec2 texCoord0;
out vec4 normal;

flat out int wit;
out vec4 uv1, uv2;
out vec2 corner;

void main() {

    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color);

    texCoord0 = UV0;

    #moj_import <flat_item.glsl>

    vertexDistance = fog_distance(Position, FogShape);
    lightMapColor = texelFetch(Sampler2, UV2 / 16, 0);
    overlayColor = texelFetch(Sampler1, UV1, 0);
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
