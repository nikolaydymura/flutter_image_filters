#include <flutter/runtime_effect.glsl>

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 2) uniform sampler2D inputImageTexture;
layout(location = 0) uniform lowp float inputDistance;
layout(location = 1) uniform highp float inputSlope;
layout(location = 3) uniform vec2 screenSize;

vec4 processColor(vec4 sourceColor, vec2 textureCoordinate){
    highp float  d = textureCoordinate.y * inputSlope  +  inputDistance;
    highp vec4 color = vec4(1.0);
    sourceColor = (sourceColor - d * color) / (1.0 -d);
    return sourceColor;
}

void main() {
    vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
    highp vec4 textureColor = texture(inputImageTexture, textureCoordinate);

    fragColor = processColor(textureColor, textureCoordinate);
}