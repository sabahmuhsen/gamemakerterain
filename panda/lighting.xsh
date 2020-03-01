/// https://github.com/GameMakerDiscord/Xpanda
#define MAX_LIGHTS 8
#define LIGHT_DIRECTIONAL 1.
#define LIGHT_POINT 2.
#define LIGHT_SPOT 3.

uniform int lightEnabled;
uniform int lightCount;
uniform Vec4 lightData[MAX_LIGHTS * 3];

Vec4 CommonLighting(Vec3 worldPosition, Vec3 worldNormal) {
    if (lightEnabled == 0) {
        return Vec4(0., 0., 0., 0.);
    }
    
    Vec4 finalColor = Vec4(0.);
    // min isn't overloaded to work with ints, that's interesting
    int n = int(min(float(lightCount), float(MAX_LIGHTS)));
    
    for (int i = 0; i < n; i++) {
        Vec3 lightPosition = lightData[i * 3].xyz;
        float type = lightData[i * 3].w;
        Vec4 lightExt = lightData[i * 3 + 1];
        Vec4 lightColor = lightData[i * 3 + 2];
        
        if (type == LIGHT_DIRECTIONAL) {
            // directional light: [x, y, z, type], [0, 0, 0, 0], [r, g, b, 0]
            Vec3 lightDir = -normalize(lightPosition);
            float NdotL = max(dot(worldNormal, lightDir), 0.);
            finalColor += lightColor * NdotL * in_Colour;
        } else if (type == LIGHT_POINT) {
            float range = lightExt.w;
            // point light: [x, y, z, type], [0, 0, 0, range], [r, g, b, 0]
            Vec3 lightDir = worldPosition - lightPosition;
            float dist = length(lightDir);
            float att = clamp((1. - dist * dist / (range * range)), 0., 1.);
            lightDir /= dist;
            att *= att;
            finalColor += lightColor * max(0., -dot(worldNormal, lightDir)) * att;
        } else if (type == LIGHT_SPOT) {
        
        }
    }
    
    return finalColor;
}