#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec3 Normal;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform float LineWidth;
uniform vec2 ScreenSize;
uniform int FogShape;

out float vertexDistance;
out vec4 vertexColor;

out vec4 pos1, pos2;
flat out vec4 pos3;
out vec2 inCoord;

const float VIEW_SHRINK = 1.0 - (1.0 / 256.0);
const mat4 VIEW_SCALE = mat4(
    VIEW_SHRINK, 0.0, 0.0, 0.0,
    0.0, VIEW_SHRINK, 0.0, 0.0,
    0.0, 0.0, VIEW_SHRINK, 0.0,
    0.0, 0.0, 0.0, 1.0
);

void main() {
    const vec2[4] corners = vec2[4](vec2(0, 0), vec2(1, 0), vec2(0, 1), vec2(1, 1));
    inCoord = corners[(gl_VertexID)%4];


    vec4 linePosStart = ProjMat * VIEW_SCALE * ModelViewMat * vec4(Position, 1.0);
    vec4 linePosEnd = ProjMat * VIEW_SCALE * ModelViewMat * vec4(Position + Normal, 1.0);
    float Width = LineWidth;

    vec4 col = Color;

    pos1 = pos2 = vec4(0);

    //if (col.rgb == vec3(0) && col.a != 1)
    //{
        int id = gl_VertexID % 4;
        float n = float(id <= 1);
        col = vec4(n, n, n, 0.2);
        Width *= 40;

        pos3 = vec4(Position, id == 1);

        if (id == 0)
            pos1 = vec4(Position, 1);
        if (id == 2)
            pos2 = vec4(Position, 1);
    //}

    vec3 ndc1 = linePosStart.xyz / linePosStart.w;
    vec3 ndc2 = linePosEnd.xyz / linePosEnd.w;

    vec2 lineScreenDirection = normalize((ndc2.xy - ndc1.xy) * ScreenSize);
    vec2 lineOffset = vec2(-lineScreenDirection.y, lineScreenDirection.x) * Width / ScreenSize;

    if (lineOffset.x < 0.0) {
        lineOffset *= -1.0;
    }

    if (gl_VertexID % 2 == 0) {
        gl_Position = vec4((ndc1) * linePosStart.w + vec3(lineOffset, 0.0), linePosStart.w);
    } else {
        gl_Position = vec4((ndc1) * linePosStart.w - vec3(lineOffset, 0.0), linePosStart.w);
    }

    vertexDistance = fog_distance(ModelViewMat, Position, FogShape);
    vertexColor = col;
}
