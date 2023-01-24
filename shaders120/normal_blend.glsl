 varying highp vec2 textureCoordinate2;
             
             uniform sampler2D inputImageTexture;
             uniform sampler2D inputImageTexture2;
             
             void main()
             {
                 lowp vec4 c2 = texture2D(inputImageTexture, textureCoordinate);
            \t lowp vec4 c1 = texture2D(inputImageTexture2, textureCoordinate2);
                 
                 lowp vec4 outputColor;
                 
                 outputColor.r = c1.r + c2.r * c2.a * (1.0 - c1.a);
            
                 outputColor.g = c1.g + c2.g * c2.a * (1.0 - c1.a);
                 
                 outputColor.b = c1.b + c2.b * c2.a * (1.0 - c1.a);
                 
                 outputColor.a = c1.a + c2.a * (1.0 - c1.a);
                 
                 gl_FragColor = outputColor;
             }