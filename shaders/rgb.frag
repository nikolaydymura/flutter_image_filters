#include <flutter/runtime_effect.glsl>

precision highp float;

out vec4 fragColor;

uniform sampler2D inputImageTexture;
layout(location = 0) uniform highp float inputRed;
layout(location = 1) uniform highp float inputGreen;
layout(location = 2) uniform highp float inputBlue;
layout(location = 3) uniform vec2 screenSize;

vec4 processColor(vec4 sourceColor){
    return vec4(sourceColor.r * inputRed, sourceColor.g * inputGreen, sourceColor.b * inputBlue, sourceColor.w);
}

void main()
{
    vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
    highp vec4 textureColor = texture(inputImageTexture, textureCoordinate);
    
    fragColor = processColor(textureColor);
}