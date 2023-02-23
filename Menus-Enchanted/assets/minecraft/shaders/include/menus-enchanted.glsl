vec2 texCord = texCoord0;
if (isNeg != 0)
    texCord.y = -texCord.y + ScrSize.y / 64; //Inverse poem

ivec2 block = ivec2(texCord);
bool variate;
vec2 offset = vec2(0);
vec4 modulator = vec4(1);

//Grass
if (block.y < 1) offset = vec2(1);

//Dirt/Stone
else if (block.y == 3)
{
    offset = vec2(((block.x * block.x + 6) % 10) / 5 != 0, 0);
}

//Stone + ores
else if(block.y > 3 && block.y < 70)
{
    offset = vec2(1, 0); //Stone

    if (noise(block, 43) % (20 + block.y / 20 * 2) == 0) offset = vec2(3); //Coal

    else if(noise(block, 29) % (20 + abs(block.y - 22) / 22 * 3) == 0) offset = vec2(2); //Copper
    
    else if(block.y >= 6 && noise(block, 4) % 25 == 0) offset = vec2(2, 3); //Iron

    if(block.y >= 39)
    {
        if(noise(block, 45) % (20 + abs(block.y + 16) / 24 * 4) == 0) offset = vec2(1, 3); //Gold
        
        else if(noise(block, 76) % 40 == 0) offset = vec2(1, 2); //Lapis
        
        if(block.y >= 55)
        {
            if(noise(block, 69) % 35 == 0) offset = vec2(0, 2); //Redstone

            else if(noise(block, 42) % (25 + (134 - block.y) / 10 * 10) == 0) offset = vec2(0, 3); //Diamonds!

            variate = ((block.x * block.x + 6 * block.y) % 10) / 5 != 0;
            if(block.y >= 68 && variate) offset = vec2(2, 1); //Deepslate
        }

    }
} 
//Deepslate + ores
else if(block.y >= 70 && block.y <= 134)
{
    offset = vec2(2, 1); //Plain deepslate

    if(noise(block, 4) % 25 == 0) offset = vec2(2, 4); //Deepslate Iron

    else if(noise(block, 45) % (20 + abs(block.y + 16) / 24 * 4) == 0) offset = vec2(1, 4); //Deepslate Gold

    else if(noise(block, 76) % 40 == 0) offset = vec2(4); //Deepslate Lapis
    
    else if(noise(block, 69) % 35 == 0) offset = vec2(4, 3); //Deepslate Redstone

    else if(noise(block, 42) % (25 + (134 - block.y) / 10 * 10) == 0) offset = vec2(0, 4); //Deepslate Diamonds

    variate = ((block.x * block.x + 6 * block.y + 5) % 10) / 5 != 0;
    if(block.y >= 132 && variate) offset = vec2(0, 1); //Bedrock (How did we get here?)
    if(block.y == 134) offset = vec2(0, 1);
}
//Nether
else if(block.y >= 135 && block.y <= 261)
{
    offset = vec2(3, 0); //Plain Netherrack

    if(noise(block, 20) % 20 == 0) offset = vec2(4, 1); //Nether Gold

    else if(noise(block, 28) % 17 == 0) offset = vec2(3, 1); //Nether Quartz
    
    else if(noise(block, 52) % 60 == 0) offset = vec2(4, 0); //Ancient Debris

    variate = ((block.x * block.x + 6 * block.y + 3) % 10) / 5 != 0;
    if((block.y <= 136 || block.y >= 261 - 2) && variate) offset = vec2(0, 1); //Bedrock (How did we get here?) x2
    if(block.y == 261) offset = vec2(0, 1);
}
if(block.y > 261) offset = vec2(2, 0);


color = texture(Sampler0, (texCord - block + offset) / 5) * modulator;
#ifndef POSITION_TEX
color *= vertexColor;
#endif