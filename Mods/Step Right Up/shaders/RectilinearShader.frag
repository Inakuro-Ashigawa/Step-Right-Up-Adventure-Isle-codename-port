#pragma header

// Define input variables
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;

// Time uniform for dynamic effects
uniform float iTime;

// Define the texture channel
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

// Shader parameters
uniform float str; // Strength of the warp effect
uniform float ok;  // Exponent for distortion

// Function to warp UV coordinates
vec2 warp(vec2 inp) {
    // Calculate the distortion factor
    float distortion = (inp.y - 0.5) * str * pow(abs(inp.x - 0.5), ok);
    inp.y -= distortion; // Apply distortion to y-coordinate
    return inp; // Return warped coordinates
}

// Main image function
void mainImage() {
    // Normalize the fragCoord to UV coordinates
    vec2 normalizedUV = fragCoord / iResolution.xy;
    // Apply the warp function
    vec2 warpedUV = warp(normalizedUV);
    // Fetch the color from the texture using the warped coordinates
    vec3 color = texture(iChannel0, warpedUV).xyz;

    // Output the final color with full alpha
    fragColor = vec4(color, 1.0);
}
