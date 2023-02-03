#include <flutter/runtime_effect.glsl>

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 0) uniform float imageWidthFactor;
layout(location = 1) uniform float imageHeightFactor;
layout(location = 4) uniform sampler2D inputImageTexture;
layout(location = 2) uniform float inputPixel;
layout(location = 3) uniform vec2 screenSize;

void main()
{
  vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
  vec2 uv  = textureCoordinate.xy;
  float dx = inputPixel * imageWidthFactor;
  float dy = inputPixel * imageHeightFactor;
  vec2 coord = vec2(dx * floor(uv.x / dx), dy * floor(uv.y / dy));
  vec3 tc = texture(inputImageTexture, coord).xyz;
  fragColor = vec4(tc, 1.0);
}