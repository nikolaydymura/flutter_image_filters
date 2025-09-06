#version 460 core
#include <flutter/runtime_effect.glsl>
precision mediump float;

layout(location = 0) uniform lowp float inputIntensityL;
layout(location = 1) uniform vec2 inputTextureCubeDataSize;
layout(location = 2) uniform vec2 screenSize;
uniform lowp sampler2D inputImageTexture;
uniform mediump sampler2D inputTextureCubeData;

out vec4 fragColor;

vec4 lookupFrom2DTexture(vec3 textureColor) {
    float blueColor = textureColor.b * 63.0;

    vec2 quad1 = vec2(0.0, 0.0);
    quad1.y = floor(floor(blueColor) / 8.0);
    quad1.x = floor(blueColor) - (quad1.y * 8.0);

    vec2 quad2 = vec2(0.0, 0.0);
    quad2.y = floor(ceil(blueColor) / 8.0);
    quad2.x = ceil(blueColor) - (quad2.y * 8.0);
            
    vec2 texPos1 = vec2(0.0, 0.0);
    texPos1.x = (quad1.x * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * textureColor.r);
    texPos1.y = (quad1.y * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * textureColor.g);

    vec2 texPos2 = vec2(0.0, 0.0);
    texPos2.x = (quad2.x * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * textureColor.r);
    texPos2.y = (quad2.y * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * textureColor.g);

    vec4 newColor1 = texture(inputTextureCubeData, texPos1);
    vec4 newColor2 = texture(inputTextureCubeData, texPos2);

    return mix(newColor1, newColor2, fract(blueColor));
}

vec4 processColor(vec4 sourceColor){
   if (inputTextureCubeDataSize.x == 1.0 || inputTextureCubeDataSize.y == 1.0) {
       return sourceColor;
   }
   vec4 newColor = lookupFrom2DTexture(clamp(sourceColor.rgb, 0.0, 1.0));
   return mix(sourceColor, vec4(newColor.rgb, sourceColor.w), inputIntensityL);
}

void main() {
   vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
   vec4 textureColor = texture(inputImageTexture, textureCoordinate);

   fragColor = processColor(textureColor);
}