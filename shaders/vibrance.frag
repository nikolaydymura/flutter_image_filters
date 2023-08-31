#include <flutter/runtime_effect.glsl>

precision highp float;

out vec4 fragColor;

uniform sampler2D inputImageTexture;
layout(location = 0) uniform lowp float inputVibrance;
layout(location = 1) uniform vec2 screenSize;

vec4 processColor(vec4 sourceColor){
    lowp float average = (sourceColor.r + sourceColor.g + sourceColor.b) / 3.0;
    lowp float mx = max(sourceColor.r, max(sourceColor.g, sourceColor.b));
    lowp float amt = (mx - average) * (-inputVibrance * 3.0);
    sourceColor.rgb = mix(sourceColor.rgb, vec3(mx), amt);
    return sourceColor;
}
void main() {
    vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
    lowp vec4 textureColor = texture(inputImageTexture, textureCoordinate);

    fragColor = processColor(textureColor);
}