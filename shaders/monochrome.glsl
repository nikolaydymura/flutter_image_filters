#version 320 es

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 0) uniform float inputIntensity;
layout(location = 1) uniform vec3 inputColor;
layout(location = 3) uniform vec2 screenSize;
layout(location = 2) uniform sampler2D inputImageTexture;

const vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);

float monoColor(float v1, float v2) {
  float lr = 2.0 * v1 * v2;
  float hr = 1.0 - 2.0 * (1.0 - v1) * (1.0 - v2);
  return v1 < 0.5 ? lr : hr;
}

void main() {
  vec2 coords = gl_FragCoord.xy / screenSize;
  vec4 textureColor = texture(inputImageTexture, coords);
  float luminance = dot(textureColor.rgb, luminanceWeighting);

  vec4 desat = vec4(luminance, luminance, luminance, 1.0);

  float lr = 2.0 * desat.r * inputColor.r;
  float hr = 1.0 - 2.0 * (1.0 - desat.r) * (1.0 - inputColor.r);
  float r = monoColor(desat.r, inputColor.r);
  vec4 outputColor = vec4(
      monoColor(desat.r, inputColor.r),
      monoColor(desat.g, inputColor.g),
      monoColor(desat.b, inputColor.b),
      1.0
      );

  fragColor = vec4(mix(textureColor.rgb, outputColor.rgb, inputIntensity), textureColor.a);
}