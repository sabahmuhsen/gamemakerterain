varying vec2 v_vTexcoord;
varying vec4 v_vColour;

#pragma include("fog.f.xsh")
/// https://github.com/GameMakerDiscord/Xpanda

uniform int fogEnabled;
uniform float fogStart;
uniform float fogEnd;
uniform vec3 fogColor;

varying vec3 v_worldPosition;
varying vec3 v_cameraPosition;

void CommonFog(inout vec4 baseColor) {
    float dist = length(v_worldPosition - v_cameraPosition);
    float f = clamp((dist - fogStart) / (fogEnd - fogStart), 0., 1.);
    baseColor.rgb = mix(baseColor.rgb, fogColor, f);
}
// include("fog.f.xsh")

void main() {
    vec4 color = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    
    CommonFog(color);
    
    gl_FragColor = color;
}