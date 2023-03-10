vec2 ScrSize = floor(ceil(2 / vec2(ProjMat[0][0], -ProjMat[1][1])) / 2);
vec2 pos = ModelViewMat[3].xy;
float dist = -(ModelViewMat * vec4(1.0)).z;

if (dist == 1734 && (pos.y - ScrSize.y == 79 || pos.y - ScrSize.y == -79))
{
    gl_Position = vec4(0, 0, 0, 1.0);
}
