#version 320 es

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 2) uniform sampler2D inputImageTexture;
layout(location = 0) uniform lowp float inputOpacity;
layout(location = 1) uniform vec2 screenSize;

vec4 processColor(vec4 sourceColor){
    return vec4(sourceColor.rgb, textureColor.a * inputOpacity);
}

void main()
{
    vec2 textureCoordinate = gl_FragCoord.xy / screenSize;
    lowp vec4 textureColor = texture(inputImageTexture, textureCoordinate);
    
    fragColor = processColor(textureColor);
}