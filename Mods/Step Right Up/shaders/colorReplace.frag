#pragma header

uniform vec3 u_colorToReplace;
uniform vec3 u_replacementColor;
uniform vec3 u_crossColor;
uniform vec3 u_silverColor;
uniform vec3 u_goldColor;
uniform bool u_useSilver;

void main() {
    vec4 col = flixel_texture2D(bitmap, openfl_TextureCoordv);
    
    // Check if the current pixel color is the cross color and change it to silver or gold
    if (distance(col.rgb, u_crossColor) < 0.1) {
        if (u_useSilver) {
            col.rgb = u_silverColor;
        } else {
            col.rgb = u_goldColor;
        }
    } else if (distance(col.rgb, u_colorToReplace) < 0.1) {
        // Replace the color for the rest of the sprite
        col.rgb = u_replacementColor;
    }
    
    gl_FragColor = col;
}
