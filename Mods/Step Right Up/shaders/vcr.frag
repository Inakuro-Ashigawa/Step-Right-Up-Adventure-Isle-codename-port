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

// Loosely based on postprocessing shader by inigo quilez, License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

void mainImage()
{
    vec2 q = fragCoord.xy / iResolution.xy;
    vec2 uv = q;
    vec3 oricol = texture( iChannel0, vec2(q.x,q.y) ).xyz;
    vec3 col;
    float x =  sin(0.3*iTime+uv.y*21.0)*sin(0.7*iTime+uv.y*29.0)*sin(0.3+0.33*iTime+uv.y*31.0)*0.0017;

    col.r = texture(iChannel0,vec2(x+uv.x+0.001,uv.y+0.001)).x+0.02;
    col.g = texture(iChannel0,vec2(x+uv.x+0.000,uv.y-0.002)).y+0.02;
    col.b = texture(iChannel0,vec2(x+uv.x-0.002,uv.y+0.000)).z+0.02;
    col.r += 0.018*texture(iChannel0,0.75*vec2(x+0.025, -0.027)+vec2(uv.x+0.001,uv.y+0.001)).x;
    col.g += 0.01*texture(iChannel0,0.75*vec2(x+-0.022, -0.02)+vec2(uv.x+0.000,uv.y-0.002)).y;
    col.b += 0.01*texture(iChannel0,0.75*vec2(x+-0.02, -0.018)+vec2(uv.x-0.002,uv.y+0.000)).z;

    col = clamp(col*0.6+0.4*col*col*1.0,0.0,1.0);

    float vig = (0.0 + 1.0*16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y));
    col *= vec3(pow(vig,0.3));

    col *= vec3(0.95,1.05,0.95);
    col *= 2.8;

    float scans = clamp( 0.35+0.35*sin(3.5*iTime+uv.y*iResolution.y*1.5), 0.0, 1.0);
    
    float s = pow(scans,1.7);
    col = col*vec3( 0.4+0.7*s) ;

    col *= 1.0+0.01*sin(110.0*iTime);
    if (uv.x < 0.0 || uv.x > 1.0)
        col *= 0.0;
    if (uv.y < 0.0 || uv.y > 1.0)
        col *= 0.0;
    
    col*=1.0-0.65*vec3(clamp((mod(fragCoord.x, 2.0)-1.0)*2.0,0.0,1.0));
    
    float comp = smoothstep( 0.1, 0.9, sin(iTime) );

    // Remove the next line to stop cross-fade between original and postprocess
    //col = mix( col, oricol, comp );

    fragColor = vec4(col, flixel_texture2D(bitmap, uv).a);
}