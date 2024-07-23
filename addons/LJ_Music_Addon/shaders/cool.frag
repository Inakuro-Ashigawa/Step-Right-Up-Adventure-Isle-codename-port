#pragma header

uniform vec4 tint;
uniform vec4 emptyTint;
uniform float percent;

void main() {
    float dx = (1.0 - openfl_TextureCoordv.x) - 0.5;
    float dy = openfl_TextureCoordv.y - 0.5;
    float mult = 1.0 - smoothstep(percent - 1, percent + 1, degrees(atan(dx, dy)) + 180.0);
    gl_FragColor = texture2D(bitmap, openfl_TextureCoordv) * mix(emptyTint, tint, mult);
}