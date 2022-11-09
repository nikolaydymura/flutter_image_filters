varying highp vec2 textureCoordinate;
            
            uniform sampler2D inputImageTexture;
            
            uniform highp vec2 inputCenter;
            uniform highp float inputRadius;
            uniform highp float inputAngle;
            
            void main()
            {
            highp vec2 textureCoordinateToUse = textureCoordinate;
            highp float dist = distance(inputCenter, textureCoordinate);
            if (dist < inputRadius)
            {
            textureCoordinateToUse -= inputCenter;
            highp float percent = (inputRadius - dist) / inputRadius;
            highp float theta = percent * percent * inputAngle * 8.0;
            highp float s = sin(theta);
            highp float c = cos(theta);
            textureCoordinateToUse = vec2(dot(textureCoordinateToUse, vec2(c, -s)), dot(textureCoordinateToUse, vec2(s, c)));
            textureCoordinateToUse += inputCenter;
            }
            
            gl_FragColor = texture2D(inputImageTexture, textureCoordinateToUse );
            
            }