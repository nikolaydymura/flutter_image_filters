#include <flutter/runtime_effect.glsl>

precision mediump float;

out vec4 fragColor;

uniform sampler2D inputImageTexture;
layout(location = 0) uniform vec2 screenSize;

const mediump vec4 colorCyan = vec4(0.333, 1.0, 1.0, 1.0);
const mediump vec4 colorMagenta = vec4(1.0, 0.333, 1.0, 1.0);
const mediump vec4 colorWhite = vec4(1.0, 1.0, 1.0, 1.0);
const mediump vec4 colorBlack = vec4(0.0, 0.0, 0.0, 1.0);

void main()
{
    vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
    highp vec2 sampleDivisor = vec2(1.0 / 200.0, 1.0 / 320.0);

    highp vec2 samplePos = textureCoordinate - mod(textureCoordinate, sampleDivisor);
    highp vec4 color = texture(inputImageTexture, samplePos);

    highp float blackDistance = distance(color, colorBlack);
    highp float whiteDistance = distance(color, colorWhite);
    highp float magentaDistance = distance(color, colorMagenta);
    highp float cyanDistance = distance(color, colorCyan);

    mediump vec4 finalColor = colorMagenta;

    highp float colorDistance = min(magentaDistance, cyanDistance);
    colorDistance = min(colorDistance, whiteDistance);
    colorDistance = min(colorDistance, blackDistance);

    if (colorDistance == blackDistance) {
        finalColor = colorBlack;
    } else if (colorDistance == whiteDistance) {
        finalColor = colorWhite;
    } else if (colorDistance == cyanDistance) {
        finalColor = colorCyan;
    } else {
        finalColor = colorMagenta;
    }

    fragColor = finalColor;
}