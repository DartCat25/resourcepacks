#version 460

#moj_import <light.glsl>
#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in vec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform float FogStart;
uniform float FogEnd;
uniform int FogShape;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec2 texCoord1;
out vec2 texCoord2;
flat out vec4 tint;

#define POTION_COUNT 17
vec3[POTION_COUNT] testColor = vec3[POTION_COUNT]
(
    vec3(51, 235, 255),  //Speed
    vec3(139, 175, 224), //Slowness
    vec3(255, 199, 0),   //Strength
    vec3(248, 36, 35),   //Instant health
    vec3(169, 101, 106), //Instant damage
    vec3(253, 255, 132), //Jump boost
    vec3(205, 92, 171),  //Regeneration
    vec3(255, 153, 0),   //Fire resistance
    vec3(152, 218, 192), //Water breathing
    vec3(246, 246, 246), //Invisibility
    vec3(194, 255, 102), //Night vision
    vec3(72, 77, 72),    //Weakness
    vec3(135, 163, 99),  //Poison
    vec3(89, 193, 6),    //Luck
    vec3(243, 207, 185), //Slow falling
    vec3(141, 130, 230), //Turtle master I (Slowness IV + Resistance III)
    vec3(141, 133, 230)  //Turtle master II (Slowness VI + Resistance IV)
);

void main() {
    ivec2 texSize = textureSize(Sampler0, 0);

    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, vec4(1)) * texelFetch(Sampler2, UV2 / 16, 0);
    tint = Color;
    texCoord0 = UV0;
    texCoord1 = UV1;
    texCoord2 = UV2;

    if (floor(texture(Sampler0, UV0).rgb * 255) == vec3(0, 0, 1))
    {
        vec3 potionColor = floor(Color.rgb * 255);

        vec2 offset = ivec2(16, 0);
        for (int i = 0; i < POTION_COUNT; i++)
        {
            if (potionColor == testColor[i])
            {
                i = min(i + 2, 17); //Clip Turtle master II 
                offset = vec2(i % 6, i / 6 % 6) * 16;
                break;
            }
        }
        texCoord0 += offset / texSize;
        tint.a = 2;
    }
}
