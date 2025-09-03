#include <flutter/runtime_effect.glsl>
precision mediump float;

layout(location = 0) uniform lowp float inputBrightness;
layout(location = 1) uniform vec2 screenSize;

uniform lowp sampler2D inputImageTexture;

out vec4 fragColor;

// Gamma correction constants for consistent color handling
const float gamma = 2.2;
const float invGamma = 1.0 / gamma;

vec3 gammaToLinear(vec3 color) {
    return pow(color, vec3(gamma));
}

vec3 linearToGamma(vec3 color) {
    return pow(color, vec3(invGamma));
}

vec4 processColor(vec4 sourceColor){
    // Convert to linear space for proper brightness adjustment
    vec3 linearColor = gammaToLinear(sourceColor.rgb);
    
    // Apply brightness in linear space
    vec3 adjustedColor = linearColor + inputBrightness;
    
    // Clamp to valid range
    adjustedColor = clamp(adjustedColor, 0.0, 1.0);
    
    // Convert back to gamma space
    vec3 finalColor = linearToGamma(adjustedColor);
    
    return vec4(finalColor, sourceColor.a);
}

void main() {
    vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
    vec4 textureColor = texture(inputImageTexture, textureCoordinate);

    fragColor = processColor(textureColor);
}