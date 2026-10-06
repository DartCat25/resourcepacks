#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:dynamictransforms.glsl>

uniform sampler2D Sampler0;

layout(location = 0) in vec2 texCoord0;
layout(location = 1) in vec4 vertexColor;
layout(location = 2) flat in int snow;

layout(location = 0) out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor;

    vec4 Col = ColorModulator; //Able to edit.

    if (snow == 1)
    {
        if (1.15 - Col.a > color.a || color.a == 0)
            discard;

        if (color.a > 1.4 - Col.a)
            color.a *= 1.5;
            
        Col.a = 1;
    }

    if (color.a == 0.0) {
        discard;
    }
    fragColor = color * Col;
}
