#version 150

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

    //Xp Bar
    if (helpCoord.x != 0)
    {
        vec2 inCoord = (helpCoord + 1) / 2;
        uv -= inCoord / 256 * vec2(182, 5);

        vec2 hCoord = helpCoord;

        vec2 offset = vec2(mod((atan(hCoord.y, hCoord.x)) / PI / 2 + 0.9, 1) * 1.025, (1 - length(hCoord)) / 5);
        if (offset.x >= xp / inCoord.x)
            discard;
        
        if(offset.x > 1 || offset.y > 1 / 36.4 || offset.x < 0 || offset.y < 0)
            discard;
        
        uv += offset / 256 * vec2(182, 182);
    }

    vec4 color = texture(Sampler0, uv);
    
    if (color.a == 0.0) discard;

    fragColor = color * ColorModulator;
    
}
