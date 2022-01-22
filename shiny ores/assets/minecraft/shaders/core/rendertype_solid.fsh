#version 150

#moj_import <fog.glsl>

#define PI 3.14159265

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec4 normal;
in vec3 pos;

out vec4 fragColor;

void main() {

    vec4 color = texture(Sampler0, texCoord0);
    vec2 texSize = textureSize(Sampler0, 0);
    int testCol = int(texelFetch(Sampler0, ivec2(texCoord0 * texSize), 0).a * 255);
    
    if (testCol == 247)
    {
        vec3 aFrag = pos;
        float frag = (aFrag.x + aFrag.y + aFrag.z) / 2;
        ivec2 uv = ivec2(texCoord0 * texSize) % 16;

        float lumShine = max(0.5, sin((abs(normal.x + normal.y) - (uv.x - uv.y) / 4.0 - frag) * 4) * 2) * 2;
        //float lumVert = vertexColor.r * 0.299 + vertexColor.g * 0.587 + vertexColor.b * 0.114;

        color.rgb *= lumShine;
    }

    color *= vertexColor * ColorModulator;

    if (color.a < 0.1) {
        discard;
    }

    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
