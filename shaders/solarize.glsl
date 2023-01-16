#version 320 es

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 2) uniform sampler2D inputImageTexture;
layout(location = 0) uniform highp float inputThreshold;
layout(location = 1) uniform vec2 screenSize;

const highp vec3 W = vec3(0.2125, 0.7154, 0.0721);

vec4 processColor(vec4 sourceColor){
    highp float luminance = dot(sourceColor.rgb, W);
    highp float inputThresholdResult = step(luminance, inputThreshold);
    highp vec3 finalColor = abs(inputThresholdResult - sourceColor.rgb);

    return vec4(finalColor, sourceColor.w);
}

void main() {
    vec2 textureCoordinate = gl_FragCoord.xy / screenSize;
    highp vec4 sourceColor = texture(inputImageTexture, textureCoordinate);
    
    fragColor = processColor(sourceColor);
}