#version 320 es

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 3) uniform sampler2D inputImageTexture;
layout(location = 0) uniform highp float inputCrossHatchSpacing;
layout(location = 1) uniform highp float inputLineWidth;
layout(location = 2) uniform vec2 screenSize;

const highp vec3 W = vec3(0.2125, 0.7154, 0.0721);

void main()
{
    vec2 textureCoordinate = gl_FragCoord.xy / screenSize;
    highp float luminance = dot(texture(inputImageTexture, textureCoordinate).rgb, W);
    lowp vec4 colorToDisplay = vec4(1.0, 1.0, 1.0, 1.0);
    if (luminance < 1.00)
    {
        if (mod(textureCoordinate.x + textureCoordinate.y, inputCrossHatchSpacing) <= inputLineWidth)
        {
            colorToDisplay = vec4(0.0, 0.0, 0.0, 1.0);
        }
    }
    if (luminance < 0.75)
    {
        if (mod(textureCoordinate.x - textureCoordinate.y, inputCrossHatchSpacing) <= inputLineWidth)
        {
            colorToDisplay = vec4(0.0, 0.0, 0.0, 1.0);
        }
    }
    if (luminance < 0.50)
    {
        if (mod(textureCoordinate.x + textureCoordinate.y - (inputCrossHatchSpacing / 2.0), inputCrossHatchSpacing) <= inputLineWidth)
        {
            colorToDisplay = vec4(0.0, 0.0, 0.0, 1.0);
        }
    }
    if (luminance < 0.3)
    {
        if (mod(textureCoordinate.x - textureCoordinate.y - (inputCrossHatchSpacing / 2.0), inputCrossHatchSpacing) <= inputLineWidth)
        {
            colorToDisplay = vec4(0.0, 0.0, 0.0, 1.0);
        }
    }
    fragColor = colorToDisplay;
}