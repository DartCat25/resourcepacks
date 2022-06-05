float panorams = textureSize(Sampler0, 0).y / textureSize(Sampler0, 0).x;

float Time = Pos.x * panorams / 6.2831853 * TIMES;

float frame = floor(Time);
float slide = Time - frame;

vec2 coords = texCoord0 * vec2(1, 1.0 / panorams) + vec2(0, 1.0 / panorams) * frame;

vec4 color1 = texture(Sampler0, coords) * vertexColor;

vec4 color2 = texture(Sampler0, coords + vec2(0, 1.0 / panorams)) * vertexColor;

color = mix(color1, color2, clamp((slide) * CHANGE_SPEED, 0, 1));
