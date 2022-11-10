  
             varying highp vec2 textureCoordinate;
             varying highp vec2 textureCoordinate2;
            
             uniform float inputThresholdSensitivity;
             uniform float inputSmoothing;
             uniform vec3 inputColorToReplace;

             uniform sampler2D inputImageTexture;
             uniform sampler2D inputImageTexture2;
             
             void main()
             {
                 vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
                 vec4 textureColor2 = texture2D(inputImageTexture2, textureCoordinate2);
                 
                 float maskY = 0.2989 * inputColorToReplace.r + 0.5866 * inputColorToReplace.g + 0.1145 * inputColorToReplace.b;
                 float maskCr = 0.7132 * (inputColorToReplace.r - maskY);
                 float maskCb = 0.5647 * (inputColorToReplace.b - maskY);
                 
                 float Y = 0.2989 * textureColor.r + 0.5866 * textureColor.g + 0.1145 * textureColor.b;
                 float Cr = 0.7132 * (textureColor.r - Y);
                 float Cb = 0.5647 * (textureColor.b - Y);
                 
                 float blendValue = 1.0 - smoothstep(inputThresholdSensitivity, inputThresholdSensitivity + inputSmoothing, distance(vec2(Cr, Cb), vec2(maskCr, maskCb)));
                 gl_FragColor = mix(textureColor, textureColor2, blendValue);
             }
