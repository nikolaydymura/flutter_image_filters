 varying highp vec2 textureCoordinate2;
            
             uniform sampler2D inputImageTexture;
             uniform sampler2D inputImageTexture2;
             
             void main()
             {
                mediump vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
                mediump vec4 textureColor2 = texture2D(inputImageTexture2, textureCoordinate2);
                mediump vec4 whiteColor = vec4(1.0);
                gl_FragColor = whiteColor - (whiteColor - textureColor) / textureColor2;
             }