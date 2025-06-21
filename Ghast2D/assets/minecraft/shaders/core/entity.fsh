#version 150

#moj_import <minecraft:fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform float GameTime;


in float vertexDistance;
in vec4 vertexColor;
in vec4 lightMapColor;
in vec4 overlayColor;
in vec2 texCoord0;
flat in int custom;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0);

    if (custom == 1) //Ghast
    {

        vec2 uv = texCoord0;
        if (texCoord0.y > 0.5) //Tentacles
        {
            float Time = GameTime * 4000;
            int frame = int(Time) % 6;
            uv.y = ((texCoord0.y - 0.5) * 2 * 64 + frame * 64 + 128) / 511.0;
        }
        else //Head
        {
            uv.y = (texCoord0.y * 2 * 64) / 511.0;
        }
        color = texture(Sampler0, uv);
    }

#ifdef ALPHA_CUTOUT
    if (color.a < ALPHA_CUTOUT) {
        discard;
    }
#endif
    color *= vertexColor * ColorModulator;
#ifndef NO_OVERLAY
    color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
#endif
#ifndef EMISSIVE
    color *= lightMapColor;
#endif



    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
