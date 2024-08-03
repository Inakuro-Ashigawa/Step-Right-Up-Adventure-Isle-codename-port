#pragma header

vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
//****MAKE SURE TO remove the parameters from mainImage

//so sorry for the names lolol
uniform float str;
uniform float ok;

vec2 warp(vec2 inp)
{
    inp.y -= (inp.y - .5)* str * pow(abs(inp.x - .5), ok);
    return inp;
}

void mainImage()
{
    vec2 uv = warp(fragCoord/iResolution.xy);
    fragColor = vec4(texture(iChannel0,uv).xyz,1.0);
}
