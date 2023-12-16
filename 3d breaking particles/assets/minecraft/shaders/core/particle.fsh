#version 150

//Made by DartCat25
//Thanks to people from ShaderLABS

#moj_import <fog.glsl>

//Cubes
#define CUBE_SIZE 1 / 16.0
#define LIGHT_DIRECTION vec3(0.341882, -0.911685, 0.227921)
#define LIGHT_POWER 1.2
#define LIGHT_BIAS 0.2

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

in float vertexDistance;
in vec2 texCoord0;
in vec4 vertexColor;

in vec4 Pos;
in vec4 glPos;

in vec2 uv1, uv2, inUV;
flat in vec2 uv3;

out vec4 fragColor;

//Got from https://iquilezles.org/articles/intersectors/
vec3 sBox(vec3 ro, vec3 rd, vec3 size, out vec3 outNormal)
{
    vec3 m = 1.0 / rd;
    vec3 n = m * ro;
    vec3 k = abs(m) * size;
    vec3 t1 = -n - k;
    vec3 t2 = -n + k;
    float tN = max( max( t1.x, t1.y ), t1.z );
    float tF = min( min( t2.x, t2.y ), t2.z );
    if( tN > tF || tF < 0.0) discard;

    outNormal = -sign(rd)*step(t1.yzx,t1.xyz)*step(t1.zxy,t1.xyz);
    
    vec3 pos = (ro + rd * tN) / size;
    vec2 tex = vec2(0);
    if (abs(outNormal.x) > 0.9)
        tex = pos.zy;
    else if (abs(outNormal.y) > 0.9)
        tex = pos.xz;
    else if (abs(outNormal.z) > 0.9)
        tex = pos.xy;

    return vec3(tex / 4 + 0.5, tN);
}


void main() {
    if (Pos.w != 0) //3D breaking particles
    {
        //Box Raytracing
        vec3 dir = normalize((-glPos).xyz);
        vec3 normal = vec3(0);
        vec3 tex = sBox(Pos.xyz, dir, vec3(CUBE_SIZE), normal);
        
        //Texture
        vec2 auv1 = round(uv1 / (uv3.x == 0 ? 1 - inUV.x : 1 - inUV.y)); //Right-up corner
        vec2 auv2 = round(uv2 / (uv3.x == 0 ? inUV.y : inUV.x)); //Left-down corner

        ivec2 res = ivec2(abs(auv1 - auv2)); //Resolution of texture
        ivec2 stp = ivec2(min(auv1, auv2)); //Left-Up corner

        vec2 texSize = textureSize(Sampler0, 0);

        vec4 color = texture(Sampler0, (stp + tex.xy * res) / texSize) * vertexColor * ColorModulator;
        if (color.a < 0.1)
            discard;

        //Light
        float light = dot(normal, LIGHT_DIRECTION) / 2 + 0.5;
        color.rgb *= light * LIGHT_POWER + LIGHT_BIAS;
        fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);

        //Depth
        vec4 clipPos = ProjMat * ModelViewMat * vec4(-dir * tex.z, 1);
        gl_FragDepth = clipPos.z / clipPos.w * 0.5 + 0.5;
    }
    else //Default
    {
        vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
        if (color.a < 0.1)
            discard;
        fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
        gl_FragDepth = gl_FragCoord.z;
    }
}
