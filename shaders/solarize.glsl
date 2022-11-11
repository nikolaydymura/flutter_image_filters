#version 320 es

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 2) uniform sampler2D inputImageTexture;
layout(location = 0) uniform highp float inputThreshold;
layout(location = 1) uniform vec2 screenSize;

const highp vec3 W = vec3(0.2125, 0.7154, 0.0721);

void main()
{
    vec2 textureCoordinate = gl_FragCoord.xy / screenSize;
    highp vec4 textureColor = texture(inputImageTexture, textureCoordinate);
    highp float luminance = dot(textureColor.rgb, W);
    highp float inputThresholdResult = step(luminance, inputThreshold);
    highp vec3 finalColor = abs(inputThresholdResult - textureColor.rgb);
    
    fragColor = vec4(finalColor, textureColor.w);
}