#include <flutter/runtime_effect.glsl>

precision highp float;

out vec4 fragColor;

uniform sampler2D inputImageTexture;
 
layout(location = 0) uniform float inputTemperature;
layout(location = 1) uniform float inputTint;
layout(location = 2) uniform vec2 screenSize;

const lowp vec3 warmFilter = vec3(0.93, 0.54, 0.0);
 
const mediump mat3 RGBtoYIQ = mat3(0.299, 0.587, 0.114, 0.596, -0.274, -0.322, 0.212, -0.523, 0.311);
const mediump mat3 YIQtoRGB = mat3(1.0, 0.956, 0.621, 1.0, -0.272, -0.647, 1.0, -1.105, 1.702);

float newColor(float v1, float v2) {
    float lr = 2.0 * v1 * v2;
    float gr = 1.0 - 2.0 * (1.0 - v1) * (1.0 - v2);
    return v1 < 0.5 ? lr : gr;
}

vec4 processColor(vec4 sourceColor){
   mediump vec3 yiq = RGBtoYIQ * sourceColor.rgb; //adjusting inputTint
   yiq.b = clamp(yiq.b + inputTint*0.5226*0.1, -0.5226, 0.5226);
   lowp vec3 rgb = YIQtoRGB * yiq;

   lowp vec3 processed = vec3(
    newColor(rgb.r, warmFilter.r),
    newColor(rgb.g, warmFilter.g),
    newColor(rgb.b, warmFilter.b));

   return vec4(mix(rgb, processed, inputTemperature), sourceColor.a);
}
 
void main() {
   vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
   lowp vec4 textureColor = texture(inputImageTexture, textureCoordinate);

   fragColor = processColor(textureColor);
}