#version 320 es
precision mediump float;
layout(location = 0) uniform lowp float inputBrightness;
layout(location = 1) uniform vec2 screenSize;
layout(location = 2) uniform lowp sampler2D inputImageTexture;

layout(location = 0) out vec4 fragColor;

vec4 processColor(vec4 sourceColor){
    return vec4((sourceColor.rgb + vec3(inputBrightness)), sourceColor.w);
}

void main() {
    vec2 textureCoordinate = gl_FragCoord.xy / screenSize;
    vec4 sourceColor = texture(inputImageTexture, textureCoordinate);

    fragColor = processColor(sourceColor);
}