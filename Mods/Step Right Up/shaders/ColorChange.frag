#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

out vec4 FragColor;

in vec2 TexCoords;

uniform sampler2D texture1;

void main()
{
    vec4 color = texture(texture1, TexCoords);
    
    // Define yellow and silver colors
    vec4 yellow = vec4(1.0, 1.0, 0.0, 1.0); // Yellow with full opacity
    vec4 silver = vec4(0.75, 0.75, 0.75, 1.0); // Silver with full opacity
    
    // Check if the color is yellow
    if (distance(color.rgb, yellow.rgb) < 0.1) // Allow a small tolerance
    {
        color = silver;
    }
    
    FragColor = color;
}
