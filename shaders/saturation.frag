#include <flutter/runtime_effect.glsl>

precision highp float;

out vec4 fragColor;

uniform sampler2D inputImageTexture;
layout(location = 0) uniform float inputSaturation;
layout(location = 1) uniform vec2 screenSize;
            
// Values from \Graphics Shaders: Theory and Practice\ by Bailey and Cunningham
const mediump vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);

vec4 processColor(vec4 sourceColor){
   lowp float luminance = dot(sourceColor.rgb, luminanceWeighting);
   lowp vec3 greyScaleColor = vec3(luminance);

   return vec4(mix(greyScaleColor, sourceColor.rgb, inputSaturation), sourceColor.w);
}

void main()
{
   vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
   lowp vec4 textureColor = texture(inputImageTexture, textureCoordinate);
   
   fragColor = processColor(textureColor);
    
}