#include <flutter/runtime_effect.glsl>

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 1) uniform sampler2D inputImageTexture;
layout(location = 0) uniform vec2 screenSize;

// Values from \Graphics Shaders: Theory and Practice\ by Bailey and Cunningham
const mediump vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);

vec4 processColor(vec4 sourceColor){
    float luminance = dot(sourceColor.rgb, luminanceWeighting);

    return vec4(vec3(luminance), sourceColor.a);
}

void main()
{
    vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
    lowp vec4 textureColor = texture(inputImageTexture, textureCoordinate);
    
    fragColor = processColor(textureColor);
}