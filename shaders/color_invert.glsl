#version 320 es

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 1) uniform sampler2D inputImageTexture;
layout(location = 0) uniform vec2 screenSize;

vec4 processColor(vec4 sourceColor){
    return vec4((1.0 - sourceColor.rgb), sourceColor.w);
}

void main()
{
    vec2 textureCoordinate = gl_FragCoord.xy / screenSize;
    lowp vec4 textureColor = texture(inputImageTexture, textureCoordinate);

    fragColor = processColor(textureColor);
}