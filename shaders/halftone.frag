#include <flutter/runtime_effect.glsl>

precision highp float;

out vec4 fragColor;

uniform sampler2D inputImageTexture;

layout(location = 0) uniform highp float inputFractionalWidthOfPixel;
layout(location = 1) uniform highp float inputAspectRatio;
layout(location = 2) uniform vec2 screenSize;

const mediump vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);

void main()
{
  vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
  highp vec2 sampleDivisor = vec2(inputFractionalWidthOfPixel, inputFractionalWidthOfPixel / inputAspectRatio);
  highp vec2 samplePos = textureCoordinate - mod(textureCoordinate, sampleDivisor) + 0.5 * sampleDivisor;
  highp vec2 textureCoordinateToUse = vec2(textureCoordinate.x, (textureCoordinate.y * inputAspectRatio + 0.5 - 0.5 * inputAspectRatio));
  highp vec2 adjustedSamplePos = vec2(samplePos.x, (samplePos.y * inputAspectRatio + 0.5 - 0.5 * inputAspectRatio));
  highp float distanceFromSamplePoint = distance(adjustedSamplePos, textureCoordinateToUse);
  lowp vec3 sampledColor = texture(inputImageTexture, samplePos).rgb;
  highp float dotScaling = 1.0 - dot(sampledColor, luminanceWeighting);
  lowp float checkForPresenceWithinDot = 1.0 - step(distanceFromSamplePoint, (inputFractionalWidthOfPixel * 0.5) * dotScaling);

  fragColor = vec4(vec3(checkForPresenceWithinDot), 1.0);
}