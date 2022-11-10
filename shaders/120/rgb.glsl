varying highp vec2 textureCoordinate;
              
              uniform sampler2D inputImageTexture;
              uniform highp float inputRed;
              uniform highp float inputGreen;
              uniform highp float inputBlue;
              
              void main()
              {
                  highp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
                  
                  gl_FragColor = vec4(textureColor.r * inputRed, textureColor.g * inputGreen, textureColor.b * inputBlue, 1.0);
              }