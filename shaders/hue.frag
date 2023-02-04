#include <flutter/runtime_effect.glsl>

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 2) uniform sampler2D inputImageTexture;
layout(location = 0) uniform mediump float inputHueAdjust;
layout(location = 1) uniform vec2 screenSize;

const highp vec4 kRGBToYPrime = vec4 (0.299, 0.587, 0.114, 0.0);
const highp vec4 kRGBToI = vec4 (0.595716, -0.274453, -0.321263, 0.0);
const highp vec4 kRGBToQ = vec4 (0.211456, -0.522591, 0.31135, 0.0);

const highp vec4 kYIQToR = vec4 (1.0, 0.9563, 0.6210, 0.0);
const highp vec4 kYIQToG = vec4 (1.0, -0.2721, -0.6474, 0.0);
const highp vec4 kYIQToB = vec4 (1.0, -1.1070, 1.7046, 0.0);

void main ()
{
    vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
    highp vec4 color = texture(inputImageTexture, textureCoordinate);

    // Convert to YIQ
    highp float YPrime = dot(color, kRGBToYPrime);
    highp float I = dot(color, kRGBToI);
    highp float Q = dot(color, kRGBToQ);

    // Calculate the hue and chroma
    highp float hue = atan(Q, I);
    highp float chroma = sqrt(I * I + Q * Q);

    // Make the user's adjustments
    hue = hue -inputHueAdjust; //why negative rotation?

    // Convert back to YIQ
    Q = chroma * sin(hue);
    I = chroma * cos(hue);

    // Convert back to RGB
    highp vec4 yIQ = vec4 (YPrime, I, Q, 0.0);
    color.r = dot(yIQ, kYIQToR);
    color.g = dot(yIQ, kYIQToG);
    color.b = dot(yIQ, kYIQToB);

    // Save the result
    fragColor = color;
}