//SHARPEN_VERTEX_SHADER 
 attribute vec4 position;
            attribute vec4 inputTextureCoordinate;
            
            uniform float imageWidthFactor; 
            uniform float imageHeightFactor; 
            uniform float sharpness;
            
            varying vec2 textureCoordinate;
            varying vec2 leftTextureCoordinate;
            varying vec2 rightTextureCoordinate; 
            varying vec2 topTextureCoordinate;
            varying vec2 bottomTextureCoordinate;
            
            varying float centerMultiplier;
            varying float edgeMultiplier;
            
            void main()
            {
                gl_Position = position;
                
                mediump vec2 widthStep = vec2(imageWidthFactor, 0.0);
                mediump vec2 heightStep = vec2(0.0, imageHeightFactor);
                
                textureCoordinate = inputTextureCoordinate.xy;
                leftTextureCoordinate = inputTextureCoordinate.xy - widthStep;
                rightTextureCoordinate = inputTextureCoordinate.xy + widthStep;
                topTextureCoordinate = inputTextureCoordinate.xy + heightStep;     
                bottomTextureCoordinate = inputTextureCoordinate.xy - heightStep;
                
                centerMultiplier = 1.0 + 4.0 * sharpness;
                edgeMultiplier = sharpness;
            }
//SHARPEN_FRAGMENT_SHADER 
precision highp float;
            
            varying highp vec2 textureCoordinate;
            varying highp vec2 leftTextureCoordinate;
            varying highp vec2 rightTextureCoordinate; 
            varying highp vec2 topTextureCoordinate;
            varying highp vec2 bottomTextureCoordinate;
            
            varying highp float centerMultiplier;
            varying highp float edgeMultiplier;
            
            uniform sampler2D inputImageTexture;
            
            void main()
            {
                mediump vec3 textureColor = texture2D(inputImageTexture, textureCoordinate).rgb;
                mediump vec3 leftTextureColor = texture2D(inputImageTexture, leftTextureCoordinate).rgb;
                mediump vec3 rightTextureColor = texture2D(inputImageTexture, rightTextureCoordinate).rgb;
                mediump vec3 topTextureColor = texture2D(inputImageTexture, topTextureCoordinate).rgb;
                mediump vec3 bottomTextureColor = texture2D(inputImageTexture, bottomTextureCoordinate).rgb;
            
                gl_FragColor = vec4((textureColor * centerMultiplier - (leftTextureColor * edgeMultiplier + rightTextureColor * edgeMultiplier + topTextureColor * edgeMultiplier + bottomTextureColor * edgeMultiplier)), texture2D(inputImageTexture, bottomTextureCoordinate).w);
            }




