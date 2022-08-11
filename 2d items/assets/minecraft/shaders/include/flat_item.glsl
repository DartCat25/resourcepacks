const vec2[4] corners = vec2[4](vec2(-1, 1), vec2(-1, -1), vec2(1, -1), vec2(1, 1));
vec2 corner = corners[gl_VertexID % 4];

vec2 texSize = textureSize(Sampler0, 0);

gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color) * texelFetch(Sampler2, UV2 / 16, 0);

if (FogStart < 100000 && texSize.x > 256 && abs(length(Normal) - 0.625) < 0.01)
{
    if (abs(abs(Normal.z) - 0.625) > 0.01)
    {
        vec3 offset = vec3(0, corner.y, 0) * IViewRotMat + vec3(corner.x, 0, 0) * (gl_VertexID / 4 % 2 * 2 - 1);
        gl_Position = ProjMat * ModelViewMat * vec4(Position + offset * 0.25, 1.0);

        vertexColor = texelFetch(Sampler2, UV2 / 16, 0) * Color;
    }
    else 
    {
        vec3 offset = vec3(corner * vec2(gl_VertexID / 4 % 2 * 2 - 1, 1), 0);
        gl_Position = ProjMat * ModelViewMat * vec4(Position + offset * 0.25, 1.0);

        vertexColor = texelFetch(Sampler2, UV2 / 16, 0) * Color;
    }
}