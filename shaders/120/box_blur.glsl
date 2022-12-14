 //VERTEX_SHADER
 attribute vec4 position;
                    attribute vec2 inputTextureCoordinate;
                    
                    uniform float texelWidthOffset; 
                    uniform float texelHeightOffset; 
                    
                    varying vec2 centerTextureCoordinate;
                    varying vec2 oneStepLeftTextureCoordinate;
                    varying vec2 twoStepsLeftTextureCoordinate;
                    varying vec2 oneStepRightTextureCoordinate;
                    varying vec2 twoStepsRightTextureCoordinate;
                    
                    void main()
                    {
                    gl_Position = position;
                    
                    vec2 firstOffset = vec2(1.5 * texelWidthOffset, 1.5 * texelHeightOffset);
                    vec2 secondOffset = vec2(3.5 * texelWidthOffset, 3.5 * texelHeightOffset);
                    
                    centerTextureCoordinate = inputTextureCoordinate;
                    oneStepLeftTextureCoordinate = inputTextureCoordinate - firstOffset;
                    twoStepsLeftTextureCoordinate = inputTextureCoordinate - secondOffset;
                    oneStepRightTextureCoordinate = inputTextureCoordinate + firstOffset;
                    twoStepsRightTextureCoordinate = inputTextureCoordinate + secondOffset;
                    }
//FRAGMENT_SHADER

precision highp float;
                    
                    uniform sampler2D inputImageTexture;
                    
                    varying vec2 centerTextureCoordinate;
                    varying vec2 oneStepLeftTextureCoordinate;
                    varying vec2 twoStepsLeftTextureCoordinate;
                    varying vec2 oneStepRightTextureCoordinate;
                    varying vec2 twoStepsRightTextureCoordinate;
                    
                    void main()
                    {
                    lowp vec4 fragmentColor = texture2D(inputImageTexture, centerTextureCoordinate) * 0.2;
                    fragmentColor += texture2D(inputImageTexture, oneStepLeftTextureCoordinate) * 0.2;
                    fragmentColor += texture2D(inputImageTexture, oneStepRightTextureCoordinate) * 0.2;
                    fragmentColor += texture2D(inputImageTexture, twoStepsLeftTextureCoordinate) * 0.2;
                    fragmentColor += texture2D(inputImageTexture, twoStepsRightTextureCoordinate) * 0.2;
                    
                    gl_FragColor = fragmentColor;
                    }
