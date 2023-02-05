#version 150

in vec4 vertexColor;

flat in vec2 flatCorner;
in vec2 Pos1;
in vec2 Pos2;
in vec4 Coords;
in vec2 position;

uniform vec4 ColorModulator;

out vec4 fragColor;

vec4 colors[] = vec4[](
    vec4(0),
    vec4(212, 140, 22, 255) / 255,
    vec4(225, 168, 23, 255) / 255,
    vec4(230, 192, 44, 255) / 255
);

#define WIDTH 5
#define HEIGHT 5
int bitmap[] = int[]
(
    0, 2, 0, 2, 3,
    2, 0, 2, 4, 4,
    0, 2, 2, 4, 4,
    2, 4, 4, 4, 4,
    1, 4, 4, 4, 4
);


void main() {
    vec4 color = vertexColor;
    if (color.a == 0.0) {
        discard;
    }

    fragColor = color * ColorModulator;

    if (flatCorner != vec2(-1))
    {
        //Actual Pos
        vec2 APos1 = Pos1;
        vec2 APos2 = Pos2;
        APos1 = round(APos1 / (flatCorner.x == 0 ? 1 - Coords.z : 1 - Coords.w)); //Right-up corner
        APos2 = round(APos2 / (flatCorner.x == 0 ? Coords.w : Coords.z)); //Left-down corner

        ivec2 res = ivec2(abs(APos1 - APos2)) - 1; //Resolution of frame
        ivec2 stp = ivec2(min(APos1, APos2)); //Left-Up corner
        ivec2 pos = ivec2(floor(position)) - stp; //Position in frame

        vec4 col = vec4(67, 33, 67, 240) / 255.0;
        col.rgb -= max(1 - length((pos - res / 2.0) / res) * 2, 0) / 10;

        ivec2 corner = min(pos, res - pos);

        if (corner.x < WIDTH && corner.y < HEIGHT)
        {
            int bit = bitmap[corner.y * WIDTH + corner.x];
            
            if (bit == 0)
                discard;
            if (bit != 4)
                col = colors[bit];
        }
        else if (corner.x == 0 || corner.y == 0)
            discard;
        else if (corner.x == 1)
            col = colors[1];
        else if (corner.y == 1)
            col = colors[3];

        fragColor = col;
    }
}
