vec2 ScrSize = 2 / vec2(ProjMat[0][0], -ProjMat[1][1]);
vec2 pos = ModelViewMat[3].xy;
float dist = -(ModelViewMat * vec4(1.0)).z;

if (dist == 1734 && (pos.y - ceil(ScrSize.y / 2) == 78 || pos.y - ceil(ScrSize.y / 2) == -80))
{
    gl_Position = vec4(0, 0, 0, 1.0);
}
