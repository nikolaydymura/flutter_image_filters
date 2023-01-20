#version 320 es
precision mediump float;

layout(location = 0) uniform lowp float inputIntensity;
layout(location = 1) uniform vec2 screenSize;
layout(location = 2) uniform lowp sampler2D inputImageTexture;
layout(location = 3) uniform mediump sampler2D inputTextureCubeData;

layout(location = 0) out vec4 fragColor;

vec2 computeSliceOffset(float slice, float slicesPerRow, vec2 sliceSize) {
  return sliceSize * vec2(mod(slice, slicesPerRow),
                          floor(slice / slicesPerRow));
}

vec4 sampleAs3DTexture(vec3 textureColor, float size, float numRows, float slicesPerRow) {
  float slice   = textureColor.z * (size - 1.0);
  float zOffset = fract(slice);                         // dist between slices

  vec2 sliceSize = vec2(1.0 / slicesPerRow,             // u space of 1 slice
                        1.0 / numRows);                 // v space of 1 slice

  vec2 slice0Offset = computeSliceOffset(floor(slice), slicesPerRow, sliceSize);
  vec2 slice1Offset = computeSliceOffset(ceil(slice), slicesPerRow, sliceSize);

  vec2 slicePixelSize = sliceSize / size;               // space of 1 pixel
  vec2 sliceInnerSize = slicePixelSize * (size - 1.0);  // space of size pixels

  vec2 uv = slicePixelSize * 0.5 + textureColor.xy * sliceInnerSize;
  vec4 slice0Color = texture(inputTextureCubeData, slice0Offset + uv);
  vec4 slice1Color = texture(inputTextureCubeData, slice1Offset + uv);
  return mix(slice0Color, slice1Color, zOffset);
}

void main() {
   vec2 textureCoordinate = gl_FragCoord.xy / screenSize;
   vec4 textureColor = texture(inputImageTexture, textureCoordinate);
   vec4 newColor = sampleAs3DTexture(textureColor.rgb, 8.0, 64.0, 8.0);
   fragColor = mix(textureColor, vec4(newColor.rgb, textureColor.w), inputIntensity);
}