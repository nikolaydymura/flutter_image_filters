  varying highp vec2 textureCoordinate2;
            
             uniform sampler2D inputImageTexture;
             uniform sampler2D inputImageTexture2;
             
             void main()
             {
                lowp vec4 base = texture2D(inputImageTexture, textureCoordinate);
                lowp vec4 overlayer = texture2D(inputImageTexture2, textureCoordinate2);
                
                gl_FragColor = vec4(min(overlayer.rgb * base.a, base.rgb * overlayer.a) + overlayer.rgb * (1.0 - base.a) + base.rgb * (1.0 - overlayer.a), 1.0);
             }