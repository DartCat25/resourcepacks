#version 150

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;

in vec2 texCoord0;
in vec2 yPos;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0);

    if (yPos.y != 0)
    {
        ivec2 uv = ivec2(texCoord0 * 256);
        float y = round(yPos.x / yPos.y) + 13;

        if (uv.y < y && uv.y > 12)
        {
            uv.y = (uv.y + 1) % 12 + 1;
            color = texture(Sampler0, (uv / 256.0));
        }
        if (uv.y >= y && uv.y <= y + 1)
            color = texture(Sampler0, vec2(uv.x, uv.y - y + 13) / 256);   
    }

    if (color.a == 0.0) discard;

    fragColor = color * ColorModulator;
}
