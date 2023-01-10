#version 150

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;

in vec2 texCoord0;
in float snow;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0);

    vec4 Col = ColorModulator; //Able to edit.

    if (snow == 1)
    {
        if (1 - Col.a > color.a || color.a == 0)
            discard;

        if (color.a > 1.4 - Col.a)
            color.a = 1;
            
        Col.a = 1;
    }

    if (color.a == 0.0) {
        discard;
    }
    fragColor = color * Col;
}
