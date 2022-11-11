#version 320 es
precision mediump float;

layout(location = 1) uniform vec2 screenSize;
layout(location = 2) uniform lowp sampler2D inputImageTexture;

layout(location = 0) out vec4 fragColor;

void main() {
    vec2 textureCoordinate = gl_FragCoord.xy / screenSize;
    fragColor = texture(inputImageTexture, textureCoordinate);
}