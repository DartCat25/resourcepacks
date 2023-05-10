#version 150

//Mini-config
#define CHANGE_SPEED 3 //Panoramas changing speed of background transitions; Decimal.
#define TIMES 2        //Amount of full cycles on one turnover; Integer.
#define HEIGHT 1080

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;

in vec2 texCoord0;
in vec4 vertexColor;
in vec2 Pos;

out vec4 fragColor;

void main() {
    vec4 color;
    if (Pos.y != -1999)
    {
        float panorams = textureSize(Sampler0, 0).y / HEIGHT;

        float Time = Pos.x * panorams / 6.2831853 * TIMES;

        float frame = floor(Time);
        float slide = Time - frame;

        vec2 coords = texCoord0 * vec2(1, 1.0 / panorams) + vec2(0, 1.0 / panorams) * frame;

        vec4 color1 = texture(Sampler0, coords) * vertexColor;

        vec4 color2 = texture(Sampler0, coords + vec2(0, 1.0 / panorams)) * vertexColor;

        color = mix(color1, color2, clamp((slide) * CHANGE_SPEED, 0, 1));
    }
    else
        color = texture(Sampler0, texCoord0) * vertexColor;

    if (color.a < 0.1) {
        discard;
    }
    fragColor = color * ColorModulator;
}
