#version 320 es

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 2) uniform sampler2D inputImageTexture;
layout(location = 0) uniform lowp float inputContrast;
layout(location = 1) uniform vec2 screenSize;

void main() {
    vec2 textureCoordinate = gl_FragCoord.xy / screenSize;
    lowp vec4 textureColor = texture(inputImageTexture, textureCoordinate);

    fragColor = vec4(((textureColor.rgb - vec3(0.5)) * inputContrast + vec3(0.5)), textureColor.w);
}