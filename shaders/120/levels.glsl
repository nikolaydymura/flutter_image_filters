 varying highp vec2 textureCoordinate;
                     
                     uniform sampler2D inputImageTexture;
                     uniform mediump vec3 inputLevelMinimum;
                     uniform mediump vec3 inputLevelMiddle;
                     uniform mediump vec3 inputLevelMaximum;
                     uniform mediump vec3 inputMinOutput;
                     uniform mediump vec3 inputMaxOutput;
                     
                     void main()
                     {
                         mediump vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
                         
                         gl_FragColor = vec4( mix(inputMinOutput, inputMaxOutput, pow(min(max(textureColor.rgb -inputLevelMinimum, vec3(0.0)) / (inputLevelMaximum - inputLevelMinimum  ), vec3(1.0)), 1.0 /inputLevelMiddle)) , textureColor.a);
                     }