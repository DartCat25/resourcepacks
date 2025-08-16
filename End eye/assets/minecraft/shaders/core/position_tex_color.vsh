#version 150

// Can't moj_import in things used during startup, when resource packs don't exist.
// This is a copy of dynamicimports.glsl and projection.glsl
layout(std140) uniform DynamicTransforms {
    mat4 ModelViewMat;
    vec4 ColorModulator;
    vec3 ModelOffset;
    mat4 TextureMat;
    float LineWidth;
};
layout(std140) uniform Projection {
    mat4 ProjMat;
};

uniform sampler2D Sampler0;

in vec3 Position;
in vec2 UV0;
in vec4 Color;

out vec2 texCoord0;
out vec4 vertexColor;
flat out int custom;

void main() {
    custom = 0;
    vec3 Pos = Position;

    texCoord0 = UV0;
    vertexColor = Color;


    if (floor(texture(Sampler0, vec2(0)) * 255) == vec4(2, 0, 0, 255))
    {
        custom = 1; //End flash
    }

    gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);
}
