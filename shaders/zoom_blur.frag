#include <flutter/runtime_effect.glsl>

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 0) uniform vec2 inputBlurCenter;
layout(location = 1) uniform float inputBlurSize;
layout(location = 2) uniform vec2 screenSize;
layout(location = 3) uniform sampler2D inputImageTexture;

void main()
{
    vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
    highp vec2 samplingOffset = 1.0/100.0 * (inputBlurCenter - textureCoordinate) * inputBlurSize;
    
    lowp vec4 fragmentColor = texture(inputImageTexture, textureCoordinate) * 0.18;
    fragmentColor += texture(inputImageTexture, textureCoordinate + samplingOffset) * 0.15;
    fragmentColor += texture(inputImageTexture, textureCoordinate + (2.0 * samplingOffset)) *  0.12;
    fragmentColor += texture(inputImageTexture, textureCoordinate + (3.0 * samplingOffset)) * 0.09;
    fragmentColor += texture(inputImageTexture, textureCoordinate + (4.0 * samplingOffset)) * 0.05;
    fragmentColor += texture(inputImageTexture, textureCoordinate - samplingOffset) * 0.15;
    fragmentColor += texture(inputImageTexture, textureCoordinate - (2.0 * samplingOffset)) *  0.12;
    fragmentColor += texture(inputImageTexture, textureCoordinate - (3.0 * samplingOffset)) * 0.09;
    fragmentColor += texture(inputImageTexture, textureCoordinate - (4.0 * samplingOffset)) * 0.05;
    
    fragColor = fragmentColor;
}