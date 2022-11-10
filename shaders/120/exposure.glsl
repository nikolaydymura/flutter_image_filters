varying highp vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform highp float inputExposure;

void main()
{
    highp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);

    gl_FragColor = vec4(textureColor.rgb * pow(2.0, inputExposure), textureColor.w);
} 