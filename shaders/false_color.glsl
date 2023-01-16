#version 320 es

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 3) uniform sampler2D inputImageTexture;
layout(location = 0) uniform vec3 inputFirstColor;
layout(location = 1) uniform vec3 inputSecondColor;
layout(location = 2) uniform vec2 screenSize;

const mediump vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);

vec4 processColor(vec4 sourceColor){
    float luminance = dot(textureColor.rgb, luminanceWeighting);

    return vec4(mix(inputFirstColor.rgb, inputSecondColor.rgb, luminance), textureColor.a)
}

void main() {
    vec2 textureCoordinate = gl_FragCoord.xy / screenSize;
    lowp vec4 textureColor = texture(inputImageTexture, textureCoordinate);

    fragColor = processColor(textureColor);
}