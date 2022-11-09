varying highp vec2 textureCoordinate;
            
            uniform sampler2D inputImageTexture;
            
            uniform highp vec2 inputCenter;
            uniform highp float inputRadius;
            uniform highp float inputAspectRatio;
            uniform highp float inputRefractiveIndex;
            
            void main()
            {
            highp vec2 textureCoordinateToUse = vec2(textureCoordinate.x, (textureCoordinate.y * inputAspectRatio + 0.5 - 0.5 * inputAspectRatio));
            highp float distanceFromCenter = distance(inputCenter, textureCoordinateToUse);
            lowp float checkForPresenceWithinSphere = step(distanceFromCenter, inputRadius);
            
            distanceFromCenter = distanceFromCenter / inputRadius;
            
            highp float normalizedDepth = inputRadius * sqrt(1.0 - distanceFromCenter * distanceFromCenter);
            highp vec3 sphereNormal = normalize(vec3(textureCoordinateToUse - inputCenter, normalizedDepth));
            
            highp vec3 refractedVector = refract(vec3(0.0, 0.0, -1.0), sphereNormal, inputRefractiveIndex);
            
            gl_FragColor = texture2D(inputImageTexture, (refractedVector.xy + 1.0) * 0.5) * checkForPresenceWithinSphere;     
            }