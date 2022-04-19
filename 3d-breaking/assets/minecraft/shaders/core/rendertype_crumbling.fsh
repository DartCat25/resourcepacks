#version 150

#define DEPTH 0.5

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform mat3 IViewRotMat;

in vec4 vertexColor;
in vec2 texCoord0;
in vec2 texCoord2;

in vec3 Pos;
in vec3 rNormal;
in mat3 mat;

out vec4 fragColor;

void main() {

    vec4 color = texture(Sampler0, texCoord0) * vertexColor;

    if (color.a < 0.1) {
        discard;
    }

    vec2 texSize = textureSize(Sampler0, 0);

    vec3 viewDir = normalize(Pos * mat);

    vec2 offs = viewDir.xy / -viewDir.z / texSize.x * DEPTH;

    if (abs(rNormal.z) >= 0.9)
        offs.x *= -1;
    if (rNormal.y > -0.9)
        offs.y *= -1;

    float i;
    vec4 rayCol;
    for (i = 1; i <= 16; i++)
    {
        rayCol = texture(Sampler0, texCoord0 + offs / 16.0 * i);
        if (rayCol.a < 0.1)
        {
            color = vec4(0.2, 0.2, 0.2, 1);
            break;
        }
    }
    
    if (i > 16)
        color = texture(Sampler0, texCoord0 + offs) * vertexColor * 2;

    fragColor = color;
}
