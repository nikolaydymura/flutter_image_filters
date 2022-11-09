varying highp vec2 textureCoordinate;
            
            uniform sampler2D inputImageTexture;
            
            uniform highp vec2 inputCenter;
            uniform highp float inputRadius;
            uniform highp float inputAspectRatio;
            uniform highp float inputRefractiveIndex;
            // uniform vec3 lightPosition;
            const highp vec3 lightPosition = vec3(-0.5, 0.5, 1.0);
            const highp vec3 ambientLightPosition = vec3(0.0, 0.0, 1.0);
            
            void main()
            {
            highp vec2 textureCoordinateToUse = vec2(textureCoordinate.x, (textureCoordinate.y * inputAspectRatio + 0.5 - 0.5 * inputAspectRatio));
            highp float distanceFrominputCenter = distance(inputCenter, textureCoordinateToUse);
            lowp float checkForPresenceWithinSphere = step(distanceFrominputCenter, inputRadius);
            
            distanceFrominputCenter = distanceFrominputCenter / inputRadius;
            
            highp float normalizedDepth = inputRadius * sqrt(1.0 - distanceFrominputCenter * distanceFrominputCenter);
            highp vec3 sphereNormal = normalize(vec3(textureCoordinateToUse - inputCenter, normalizedDepth));
            
            highp vec3 refractedVector = 2.0 * refract(vec3(0.0, 0.0, -1.0), sphereNormal, inputRefractiveIndex);
            refractedVector.xy = -refractedVector.xy;
            
            highp vec3 finalSphereColor = texture2D(inputImageTexture, (refractedVector.xy + 1.0) * 0.5).rgb;
            
            // Grazing angle lighting
            highp float lightingIntensity = 2.5 * (1.0 - pow(clamp(dot(ambientLightPosition, sphereNormal), 0.0, 1.0), 0.25));
            finalSphereColor += lightingIntensity;
            
            // Specular lighting
            lightingIntensity  = clamp(dot(normalize(lightPosition), sphereNormal), 0.0, 1.0);
            lightingIntensity  = pow(lightingIntensity, 15.0);
            finalSphereColor += vec3(0.8, 0.8, 0.8) * lightingIntensity;
            
            gl_FragColor = vec4(finalSphereColor, 1.0) * checkForPresenceWithinSphere;
            }