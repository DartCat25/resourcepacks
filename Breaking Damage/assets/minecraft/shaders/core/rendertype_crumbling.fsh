#version 150

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float GameTime;

in vec4 vertexColor;
in vec2 texCoord0;
in vec2 texCoord2;
in vec4 normal;

out vec4 fragColor;

void main() {
    
    vec4 color = int(GameTime * 5000) % 2 == 0 ? vec4(0.59, 0.28, 0.28, 1) : vec4(0.5, 0.5, 0.5, 1);

    fragColor = color * ColorModulator;
}
