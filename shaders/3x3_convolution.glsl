precision highp float;
            
            uniform sampler2D inputImageTexture;
            
            uniform mediump mat3 inputConvolutionMatrix;
            
            varying vec2 textureCoordinate;
            varying vec2 leftTextureCoordinate;
            varying vec2 rightTextureCoordinate;
            
            varying vec2 topTextureCoordinate;
            varying vec2 topLeftTextureCoordinate;
            varying vec2 topRightTextureCoordinate;
            
            varying vec2 bottomTextureCoordinate;
            varying vec2 bottomLeftTextureCoordinate;
            varying vec2 bottomRightTextureCoordinate;
            
            void main()
            {
                mediump vec4 bottomColor = texture2D(inputImageTexture, bottomTextureCoordinate);
                mediump vec4 bottomLeftColor = texture2D(inputImageTexture, bottomLeftTextureCoordinate);
                mediump vec4 bottomRightColor = texture2D(inputImageTexture, bottomRightTextureCoordinate);
                mediump vec4 centerColor = texture2D(inputImageTexture, textureCoordinate);
                mediump vec4 leftColor = texture2D(inputImageTexture, leftTextureCoordinate);
                mediump vec4 rightColor = texture2D(inputImageTexture, rightTextureCoordinate);
                mediump vec4 topColor = texture2D(inputImageTexture, topTextureCoordinate);
                mediump vec4 topRightColor = texture2D(inputImageTexture, topRightTextureCoordinate);
                mediump vec4 topLeftColor = texture2D(inputImageTexture, topLeftTextureCoordinate);
            
                mediump vec4 resultColor = topLeftColor * inputConvolutionMatrix[0][0] + topColor * inputConvolutionMatrix[0][1] + topRightColor * inputConvolutionMatrix[0][2];
                resultColor += leftColor * inputConvolutionMatrix[1][0] + centerColor * inputConvolutionMatrix[1][1] + rightColor * inputConvolutionMatrix[1][2];
                resultColor += bottomLeftColor * inputConvolutionMatrix[2][0] + bottomColor * inputConvolutionMatrix[2][1] + bottomRightColor * inputConvolutionMatrix[2][2];
            
                gl_FragColor = resultColor;
            }