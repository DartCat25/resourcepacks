#version 150

in vec3 Position;
in vec2 UV0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform sampler2D Sampler0;

out vec2 texCoord0;

void main() {
    
    const vec2[4] corners = vec2[4](vec2(0), vec2(0, 1), vec2(1, 1), vec2(1, 0));

    ivec2 samplepos = ivec2(UV0 * textureSize(Sampler0, 0)) - ivec2(vec2(26, 32) * corners[gl_VertexID]);
    
    if (ivec4(texelFetch(Sampler0, samplepos, 0) * 255.0) == ivec4(255, 0, 0, 0)) {
        gl_Position = ProjMat * ModelViewMat * vec4(Position + vec3(0, 0, 300), 1.0);
    } else {
        gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    }

    texCoord0 = UV0;
}
