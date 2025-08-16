#version 150

// // CONFIG // //
#define OPTION 1 //1-6
//1 - sin1
//2 - sin2
//3 - sin3, popeye
//4 - par1
//5 - par2, popeye
//6 - sin with different eyelids

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

    #if OPTION == 1
        if (sin(((uv.x * 64 - 12) / 40) * PI) * anim * 0.19 < abs(uv.y - 0.5))
    #elif OPTION == 2
        if (sin(((uv.x * 64 - 13) / 38) * PI) * anim * 0.2 < abs(uv.y - 0.5))
    #elif OPTION == 3
        if (sin(uv.x * PI) * anim * 0.25 < abs(uv.y - 0.5))
    #elif OPTION == 4
        if (-(uv.x - 0.8) * (uv.x - 0.2) * anim * 2.1 < abs(uv.y - 0.5))
    #elif OPTION == 5
        if (-(uv.x - 1) * (uv.x) * anim < abs(uv.y - 0.5))
    #elif OPTION == 6
        float f = sin(((uv.x * 64 - 12) / 40) * PI);
        float f1 = -f * mix(0.25, 0.8, anim) * 0.19; //Lower eyelid
        float f2 = f * mix(-0.25, 1, anim) * 0.19; //Upper eyelid
        if (uv.y - 0.5 < f1 || f2 < uv.y - 0.5)
    #endif
            discard;
    }
    
    
    if (color.a == 0.0) {
        discard;
    }
    fragColor = color * ColorModulator;
}
