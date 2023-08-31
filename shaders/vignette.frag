#include <flutter/runtime_effect.glsl>

precision highp float;

out vec4 fragColor;
 
layout(location = 0) uniform lowp vec2 inputVignetteCenter;
layout(location = 1) uniform lowp vec3 inputVignetteColor;
layout(location = 2) uniform highp float inputVignetteStart;
layout(location = 3) uniform highp float inputVignetteEnd;
layout(location = 4) uniform vec2 screenSize;
uniform sampler2D inputImageTexture;
 
void main(){
    vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
    lowp vec3 rgb = texture(inputImageTexture, textureCoordinate).rgb;
    lowp float d = distance(textureCoordinate, vec2(inputVignetteCenter.x, inputVignetteCenter.y));
    lowp float percent = smoothstep(inputVignetteStart, inputVignetteEnd, d);
    fragColor = vec4(mix(rgb.x, inputVignetteColor.x, percent), mix(rgb.y, inputVignetteColor.y, percent), mix(rgb.z, inputVignetteColor.z, percent), 1.0);
}