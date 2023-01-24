#version 320 es

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 3) uniform sampler2D inputImageTexture;
layout(location = 0) uniform lowp mat4 inputColorMatrix;
layout(location = 1) uniform lowp float inputIntensityCM;
layout(location = 2) uniform vec2 screenSize;

vec4 processColor(vec4 sourceColor){
    lowp vec4 outputColor = sourceColor * inputColorMatrix;

    return (inputIntensityCM * outputColor) + ((1.0 - inputIntensityCM) * sourceColor);
}

void main()
{
    vec2 textureCoordinate = gl_FragCoord.xy / screenSize;
    lowp vec4 textureColor = texture(inputImageTexture, textureCoordinate);
    
    fragColor = processColor(textureColor);
}