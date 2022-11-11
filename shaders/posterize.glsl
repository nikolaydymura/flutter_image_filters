#version 320 es

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 2) uniform sampler2D inputImageTexture;
layout(location = 0) uniform highp float inputColorLevels;
layout(location = 1) uniform vec2 screenSize;

void main()
{
   vec2 textureCoordinate = gl_FragCoord.xy / screenSize;
   highp vec4 textureColor = texture(inputImageTexture, textureCoordinate);
   
   fragColor = floor((textureColor * inputColorLevels) + vec4(0.5)) / inputColorLevels;
}