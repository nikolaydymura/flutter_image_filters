#version 320 es

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 2) uniform sampler2D inputImageTexture;
layout(location = 0) uniform highp float inputExposure;
layout(location = 1) uniform vec2 screenSize;

vec4 processColor(vec4 sourceColor){
    return vec4(textureColor.rgb * pow(2.0, inputExposure), textureColor.w);
}

void main()
{
    vec2 textureCoordinate = gl_FragCoord.xy / screenSize;
    highp vec4 textureColor = texture(inputImageTexture, textureCoordinate);

    fragColor = processColor(textureColor);
} 