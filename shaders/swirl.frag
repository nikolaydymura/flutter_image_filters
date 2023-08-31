#include <flutter/runtime_effect.glsl>

precision highp float;

out vec4 fragColor;

uniform sampler2D inputImageTexture;

layout(location = 0) uniform highp vec2 inputCenter;
layout(location = 1) uniform highp float inputRadius;
layout(location = 2) uniform highp float inputAngle;
layout(location = 3) uniform vec2 screenSize;

void main()
{
    vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
    highp vec2 textureCoordinateToUse = textureCoordinate;
    highp float dist = distance(inputCenter, textureCoordinate);
    if (dist < inputRadius)
    {
        textureCoordinateToUse -= inputCenter;
        highp float percent = (inputRadius - dist) / inputRadius;
        highp float theta = percent * percent * inputAngle * 8.0;
        highp float s = sin(theta);
        highp float c = cos(theta);
        textureCoordinateToUse = vec2(dot(textureCoordinateToUse, vec2(c, -s)), dot(textureCoordinateToUse, vec2(s, c)));
        textureCoordinateToUse += inputCenter;
    }

    fragColor = texture(inputImageTexture, textureCoordinateToUse);

}