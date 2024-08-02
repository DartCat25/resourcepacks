wit = 0;

const vec2[4] corners = vec2[4](vec2(-1, 1), vec2(-1, -1), vec2(1, -1), vec2(1, 1));
corner = corners[gl_VertexID % 4];

gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
#ifndef NO_LIGHTMAP
vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color) * texelFetch(Sampler2, UV2 / 16, 0);
#endif
if (FogStart < 100000 && abs(length(mat3(ModelViewMat) * Normal)) < 0.01 && length(Normal) == 0) //Not in hand or GUI, weird Normal length from display.
{
    uv1 = uv2 = vec4(0);
    if (gl_VertexID % 4 == 0)
        uv1 = vec4(UV0 * textureSize(Sampler0, 0), 1, 1);
    if (gl_VertexID % 4 == 2)
        uv2 = vec4(UV0 * textureSize(Sampler0, 0), 1, 1);

    vec3 absNormal = normalize(Normal);
    wit = 1;
    if (true) //Check if it isn't throwable.
    {
        vec3 pos = mat3(ModelViewMat) * vec3(Position.x, 0, Position.z);

        int back = int(pos.z < 0 || (pos.z == 0 && (pos.y > 0 ^^ Position.y > 0)));

        wit += back;

        vec3 offset = vec3(0, corner.y, 0) + vec3(corner.x, 0, 0) * mat3(ModelViewMat) * (back * 2 - 1);
        gl_Position = ProjMat * ModelViewMat * vec4(Position + offset * 0.25, 1.0);
    }
    // else 
    // {
    //     vec3 offset = vec3(corner * vec2(float(Normal.y > 0) * 2 - 1, 1), 0);

    //     if (ModelViewMat[0][0] != 1) //Rotate on pickup.
    //         offset.xz = (vec3(offset.x, 0, offset.z)).xz;

    //     gl_Position = ProjMat * ModelViewMat * vec4(Position + offset * 0.25, 1.0);
    // }
    #ifndef NO_LIGHTMAP
    vertexColor = texelFetch(Sampler2, UV2 / 16, 0) * Color;
    #else
    vertexColor = Color;
    #endif
}