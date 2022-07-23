#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec4 normal;

in float notEuclid;
in vec3 pos;
flat in vec3 v1, v2, v3;

out vec4 fragColor;

//Got from https://iquilezles.org/articles/intersectors/
vec3 triIntersect( in vec3 ro, in vec3 rd, in vec3 v0, in vec3 v1, in vec3 v2 )
{
    vec3 v1v0 = v1 - v0;
    vec3 v2v0 = v2 - v0;
    vec3 rov0 = ro - v0;
    vec3  n = cross( v1v0, v2v0 );
    vec3  q = cross( rov0, rd );
    float d = 1.0/dot( rd, n );
    float u = d*dot( -q, v2v0 );
    float v = d*dot(  q, v1v0 );
    float t = d*dot( -n, rov0 );
    if( abs(u - 0.5) > 0.5 || abs(v - 0.5) > 0.5 ) t = -1.0;
    return vec3( t, u, v );
}

void main() {
    vec4 color = texture(Sampler0, texCoord0);

    if (notEuclid != 0)
    {
        if (triIntersect(pos, normalize(-pos), v1, v2, v3).r < 0)
            discard;
    }

    color *= vertexColor * ColorModulator;

    if (color.a < 0.1)
        discard;

    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
