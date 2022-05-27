#version 150

#moj_import <config.glsl>

#define PI 3.1415926

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform vec2 ScreenSize;

in vec2 texCoord0;
in vec2 helpCoord;
in float xp;

out vec4 fragColor;

void main() {
    
    vec2 uv = texCoord0;

    //Xp and horse's jump Bars
    if (helpCoord.x != 0)
    {
        vec2 inCoord = (helpCoord + 1) / 2;
        uv -= inCoord * vec2(0.7109375, 0.01953125);

        vec2 hCoord = helpCoord;

        #if HORISONTAL == 1
            hCoord.x *= -1;
        #endif

        vec2 offset = vec2(mod((atan(hCoord.y, hCoord.x)) / PI / 2 + 0.9025, 1), (1 - length(hCoord)) / 5);

        #ifndef SUPER_SECRET_SETTING
            offset.x *= 1.025;
        #endif

        if (offset.x >= xp / inCoord.x)
            discard;
        
        if(offset.x > 1 || offset.y > 1 / 36.4 || offset.x < 0 || offset.y < 0)
            discard;
        
        uv += offset * vec2(0.7109375);
    }

    vec4 color = texture(Sampler0, uv);
    
    if (color.a == 0.0) discard;

    fragColor = color * ColorModulator;
    
}
