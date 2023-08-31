#include <flutter/runtime_effect.glsl>

precision highp float;

out vec4 fragColor;

uniform sampler2D inputImageTexture;

layout(location = 0) uniform highp float inputAspectRatio;
layout(location = 1) uniform highp vec2 inputCenter;
layout(location = 2) uniform highp float inputRadius;
layout(location = 3) uniform highp float inputScale;
layout(location = 4) uniform vec2 screenSize;

void main()
{
    vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
    highp vec2 textureCoordinateToUse = vec2(textureCoordinate.x, (textureCoordinate.y * inputAspectRatio + 0.5 - 0.5 * inputAspectRatio));
    highp float dist = distance(inputCenter, textureCoordinateToUse);
    textureCoordinateToUse = textureCoordinate;

    if (dist < inputRadius)
    {
        textureCoordinateToUse -= inputCenter;
        highp float percent = 1.0 - ((inputRadius - dist) / inputRadius) * inputScale;
        percent = percent * percent;

        textureCoordinateToUse = textureCoordinateToUse * percent;
        textureCoordinateToUse += inputCenter;
    }

    fragColor = texture(inputImageTexture, textureCoordinateToUse);
}