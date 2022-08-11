const vec2[4] corners = vec2[4](vec2(-1, 1), vec2(-1, -1), vec2(1, -1), vec2(1, 1));
vec2 corner = corners[gl_VertexID % 4];

vec2 texSize = textureSize(Sampler0, 0);

gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color) * texelFetch(Sampler2, UV2 / 16, 0);

if (FogStart < 100000 && texSize.x > 256 && abs(length(Normal) - 0.625) < 0.01) //Not in hand, atlas is not a mob, weird Normal length from display.
{
    vec3 absNormal = IViewRotMat * normalize(Normal);

    if (abs(absNormal.y) - 1 > -0.001) //Check if it isn't throwable.
    {
        vec3 offset = vec3(0, corner.y, 0) * IViewRotMat + vec3(corner.x, 0, 0) * (float(absNormal.y >= -0.1) * 2 - 1);
        gl_Position = ProjMat * ModelViewMat * vec4(Position + offset * 0.25, 1.0);        
    }
    else 
    {
        vec3 offset = vec3(corner * vec2(float(Normal.y > 0) * 2 - 1, 1), 0);

        if (ModelViewMat[0][0] != 1) //Rotate on pickup.
            offset.xz = (IViewRotMat * vec3(offset.x, 0, offset.z)).xz;

        gl_Position = ProjMat * ModelViewMat * vec4(Position + offset * 0.25, 1.0);
    }

    vertexColor = texelFetch(Sampler2, UV2 / 16, 0) * Color;
}