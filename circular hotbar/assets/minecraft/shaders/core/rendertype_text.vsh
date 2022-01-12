#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform vec2 ScreenSize;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    vertexDistance = cylindrical_distance(ModelViewMat, IViewRotMat * Position);    
    texCoord0 = UV0;

    //Xp number offset
    int Scale = int(ScreenSize.x * ProjMat[0][0] / 2);
    vec2 ScrSize = ScreenSize / Scale;
    vec3 isXpGreen = abs(Color.rgb - vec3(0x7e, 0xfc, 0x20) / 255);
    if (Position.z == 0 && Position.y >= ScrSize.y - 36 && Position.y <= ScrSize.y - 25
    && (Color.rgb == vec3(0, 0, 0) || (isXpGreen.r < 0.1 && isXpGreen.r < 0.1 && isXpGreen.r < 0.1)))
    {
        vec3 Pos = Position;
        
        Pos.xy -= vec2(ScrSize.x / 2 - 104, 3);

        gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);
    }
}
