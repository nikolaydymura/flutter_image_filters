#include <flutter/runtime_effect.glsl>

precision highp float;

out vec4 fragColor;

uniform sampler2D inputImageTexture;
layout(location = 0) uniform highp float inputThresholdS;
layout(location = 1) uniform vec2 screenSize;

const mediump vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);

vec4 processColor(vec4 sourceColor){
    highp float luminance = dot(sourceColor.rgb, luminanceWeighting);
    highp float inputThresholdResult = step(luminance, inputThresholdS);
    highp vec3 finalColor = abs(inputThresholdResult - sourceColor.rgb);

    return vec4(finalColor, sourceColor.w);
}

void main() {
    vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
    highp vec4 textureColor = texture(inputImageTexture, textureCoordinate);
    
    fragColor = processColor(textureColor);
}