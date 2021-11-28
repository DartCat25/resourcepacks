vec4 pos = ProjMat * ModelViewMat * vec4(1.0);
float dist = -(ModelViewMat * vec4(1.0)).z;
vec2 screenPos = (pos.xyz / pos.w).xy / 2 + 0.5;


#ifdef  HEAD
    dist -= 0.0039;
#endif

bool isPlace = false;

//Config: rotates in ...
#ifdef ADVANCEMENT_POPOUT
    isPlace = isPlace || (dist == 1034);
#endif
#ifdef ADVANCEMENT_ICON_SELECTED
    isPlace = isPlace || (dist == 1434);
#endif
#ifdef ON_CURSOR
    isPlace = isPlace || (dist == 1602);
#endif
#ifdef INVENTORY
    isPlace = isPlace || (dist == 1734);
#endif
#ifdef ADVANCEMENT_ICON
    isPlace = isPlace || (dist == 1834 && screenPos.y > 0.2);
#endif
#ifdef HOTBAR
    isPlace = isPlace || (dist == 1834 && screenPos.y <= 0.2);
#endif


bool isItem = true;

//Config: type
#ifndef FLAT
    isItem = !(Position.z == -0.03125 || Position.z == 0.03125);
#endif
#ifndef MODEL
    isItem = isItem && !(Position.z != -0.03125 && Position.z != 0.03125);
#endif

if (isPlace && isItem)
{
    vec4 rotation = vec4(Position, 0) * Rotate(GameTime * ROTATE_SPEED, Y);
    gl_Position = ProjMat * ModelViewMat * vec4(rotation.xyz, 1.0);

    //Normals (for shadows); Glint hasn't this.
    #ifndef NONORMALS
        vec4 rotationMormal = vec4(Normal, 0) * Rotate(GameTime * ROTATE_SPEED, Y);
        vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, rotationMormal.xyz, Color) * texelFetch(Sampler2, UV2 / 16, 0);
    #endif
}
