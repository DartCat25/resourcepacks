#version 460

in vec3 Position;
in vec4 Color;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

uniform vec2 ScreenSize;

out vec4 vertexColor;
out vec4 Coords;
out vec2 position;

flat out vec2 flatCorner;
out vec2 Pos1;
out vec2 Pos2;

void main() {
    vertexColor = Color;
    
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    Coords = vec4(-1);
    position, Pos1, Pos2, flatCorner = vec2(-1);

    //Tooltip frame
    if (Color.r != 0 && Color.g == 0 && Color.b != 0 && ProjMat[3][0] == -1)
    {        
        int id = gl_VertexID / 4;

        int vertID = (gl_VertexID) % 4;
        const vec2[4] corners = vec2[4](vec2(0), vec2(0, 1), vec2(1, 1), vec2(1, 0));
        vec2 ScrSize = 2 / vec2(ProjMat[0][0], -ProjMat[1][1]);
        vec3 Pos = Position - vec3(corners[(vertID + 1) % 4] * 2 - 1, 0);

        Pos1 = Pos2 = vec2(0);
        if (vertID == 0) Pos1 = Pos.xy;
        if (vertID == 2) Pos2 = Pos.xy;

        Coords.xy = ScrSize;
        Coords.zw = flatCorner = corners[vertID];
        position = Pos.xy;

        if (id != 2)
            Pos.xy = vec2(0);        
    
        gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);
    }
}