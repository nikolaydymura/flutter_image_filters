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
    vec2 texPos1 = textureCoordinate + samplingOffset;
    fragmentColor += texture(inputImageTexture, texPos1) * 0.15;
    vec2 texPos2 = textureCoordinate + (2.0 * samplingOffset);
    fragmentColor += texture(inputImageTexture, texPos2) *  0.12;
    vec2 texPos3 = textureCoordinate + (3.0 * samplingOffset);
    fragmentColor += texture(inputImageTexture, texPos3) * 0.09;
    vec2 texPos4 = textureCoordinate + (4.0 * samplingOffset);
    fragmentColor += texture(inputImageTexture, texPos4) * 0.05;
    vec2 texPos5 = textureCoordinate - samplingOffset;
    fragmentColor += texture(inputImageTexture, texPos5) * 0.15;
    vec2 texPos6 = textureCoordinate - (2.0 * samplingOffset);
    fragmentColor += texture(inputImageTexture, texPos6) *  0.12;
    vec2 texPos7 = textureCoordinate - (3.0 * samplingOffset);
    fragmentColor += texture(inputImageTexture, texPos7) * 0.09;
    vec2 texPos8 = textureCoordinate - (4.0 * samplingOffset);
    fragmentColor += texture(inputImageTexture, texPos8) * 0.05;
    
    fragColor = fragmentColor;
}