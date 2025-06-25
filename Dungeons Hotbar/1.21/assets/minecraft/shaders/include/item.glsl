vec3 Pos = Position;
vec2 ScrSize = 2 / vec2(ProjMat[0][0], -ProjMat[1][1]);

#ifdef HEAD
//Pos.z -= 100;
#endif

if (ProjMat[3][0] == -1 && abs(Pos.z - 550) <= 16 && abs(ScrSize.y - Pos.y - 10) <= 16)
{
    float center = floor(ScrSize.x / 2) - 109;
    if (abs(center - Pos.x) <= 9)
    {
        Pos.x -= 72;
    }
    if (abs(floor(ScrSize.x / 2) + 109 - Pos.x) <= 9)
    {
        Pos.x -= 290;
    }
    else
    {
        for (int i = 0; i < 9; i++)
        {
            center = floor(ScrSize.x / 2) - 80 + i * 20;
            if (abs(center - Pos.x) <= 9)
            {
                Pos.x += -center + floor(ScrSize.x / 2) - 148 + i * 33 + int(i > 3) * 64;
                break;
            }
        }
    }
    Pos.y -= 23;
}

gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);