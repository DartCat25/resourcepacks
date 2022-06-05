#version 150

//Code by DartCat25
//https://www.planetminecraft.com/texture-pack/menus-enchanted/

//Mini-config for Menus - Enchanted part
//#define EXPECTED_TEXSIZE vec2(80) //Expected size of texture (it may add some mod support). Remove first "//" to make it work.

//Mini-config for background transitions part
#define CHANGE_SPEED 3 //Panoramas changing speed of background transitions; Decimal.
#define TIMES 2        //Amount of full cycles on one turnover; Integer.

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;

in vec2 texCoord0;
in vec4 vertexColor;
in vec4 Pos;
in float isNeg;
in vec2 ScrSize;

out vec4 fragColor;

// A single iteration of Bob Jenkins' One-At-A-Time hashing algorithm.
int hash(int x) {
    x += ( x << 10 );
    x ^= ( x >>  6 );
    x += ( x <<  3 );
    x ^= ( x >> 11 );
    x += ( x << 15 );
    return x;
}

int noise(ivec2 v, int seed) {
    return hash(v.x ^ hash(v.y + seed) ^ seed);
}

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor;
    vec2 texSize = textureSize(Sampler0, 0);
    if (Pos.y != -1999)
    {
        if (texSize.x != texSize.y)
        {
            #moj_import <background-transitions.glsl>
        }
    }
    else
    #ifdef EXPECTED_TEXSIZE
        if(texSize == EXPECTED_TEXSIZE)
    #endif
    {
        #moj_import <menus-enchanted.glsl>
    }
    
    if (color.a < 0.1) {
        discard;
    }
    fragColor = color * ColorModulator;
}
