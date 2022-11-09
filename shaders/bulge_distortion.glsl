varying highp vec2 textureCoordinate;
            
            uniform sampler2D inputImageTexture;
            
            uniform highp float inputAspectRatio;
            uniform highp vec2 inputCenter;
            uniform highp float inputRadius;
            uniform highp float inputScale;
            
            void main()
            {
            highp vec2 textureCoordinateToUse = vec2(textureCoordinate.x, (textureCoordinate.y * inputAspectRatio + 0.5 - 0.5 * inputAspectRatio));
            highp float dist = distance(inputCenter, textureCoordinateToUse);
            textureCoordinateToUse = textureCoordinate;
            
            if (dist < inputRadius)
            {
            textureCoordinateToUse -= inputCenter;
            highp float percent = 1.0 - ((inputRadius - dist) / inputRadius) * inputScale;
            percent = percent * percent;
            
            textureCoordinateToUse = textureCoordinateToUse * percent;
            textureCoordinateToUse += inputCenter;
            }
            
            gl_FragColor = texture2D(inputImageTexture, textureCoordinateToUse );    
            }