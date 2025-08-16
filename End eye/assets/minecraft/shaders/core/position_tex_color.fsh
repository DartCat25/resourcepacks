#version 150

#define PI 3.1415926

// Can't moj_import in things used during startup, when resource packs don't exist.
// This is a copy of dynamicimports.glsl
layout(std140) uniform DynamicTransforms {
    mat4 ModelViewMat;
    vec4 ColorModulator;
    vec3 ModelOffset;
    mat4 TextureMat;
    float LineWidth;
};

uniform sampler2D Sampler0;

in vec2 texCoord0;
in vec4 vertexColor;
flat in int custom;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor;
    
    if (custom == 1) //End flash
    {
        float anim = vertexColor.a;
        vec2 texSize = textureSize(Sampler0, 0);
        vec2 uv = (floor(texCoord0 * texSize) + vec2(0.5)) / texSize;

        if (-(uv.x - 0.8) * (uv.x - 0.2) * anim * 2 < abs(uv.y - 0.5))
        //if (-(uv.x - 1) * (uv.x) * anim < abs(uv.y - 0.5))
            discard;
    }
    
    
    if (color.a == 0.0) {
        discard;
    }
    fragColor = color * ColorModulator;
}
