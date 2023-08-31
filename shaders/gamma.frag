#include <flutter/runtime_effect.glsl>

precision highp float;

out vec4 fragColor;

uniform sampler2D inputImageTexture;
layout(location = 0) uniform lowp float inputGamma;
layout(location = 1) uniform vec2 screenSize;

vec4 processColor(vec4 sourceColor){
     return vec4(pow(sourceColor.rgb, vec3(inputGamma)), sourceColor.w);
}

void main() {
    vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
    lowp vec4 textureColor = texture(inputImageTexture, textureCoordinate);

    fragColor = processColor(textureColor);
}