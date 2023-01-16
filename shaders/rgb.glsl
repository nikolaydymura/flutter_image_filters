#version 320 es

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 4) uniform sampler2D inputImageTexture;
layout(location = 0) uniform highp float inputRed;
layout(location = 1) uniform highp float inputGreen;
layout(location = 2) uniform highp float inputBlue;
layout(location = 3) uniform vec2 screenSize;

vec4 processColor(vec4 sourceColor){
    return vec4(textureColor.r * inputRed, textureColor.g * inputGreen, textureColor.b * inputBlue, textureColor.w);
}

void main()
{
    vec2 textureCoordinate = gl_FragCoord.xy / screenSize;
    highp vec4 textureColor = texture(inputImageTexture, textureCoordinate);
    
    fragColor = processColor(textureColor);
}