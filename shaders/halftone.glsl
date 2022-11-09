 varying highp vec2 textureCoordinate;

            uniform sampler2D inputImageTexture;

            uniform highp float inputFractionalWidthOfPixel;
            uniform highp float inputAspectRatio;

            const highp vec3 W = vec3(0.2125, 0.7154, 0.0721);

            void main()
            {
              highp vec2 sampleDivisor = vec2(inputFractionalWidthOfPixel, inputFractionalWidthOfPixel / inputAspectRatio);
              highp vec2 samplePos = textureCoordinate - mod(textureCoordinate, sampleDivisor) + 0.5 * sampleDivisor;
              highp vec2 textureCoordinateToUse = vec2(textureCoordinate.x, (textureCoordinate.y * inputAspectRatio + 0.5 - 0.5 * inputAspectRatio));
              highp vec2 adjustedSamplePos = vec2(samplePos.x, (samplePos.y * inputAspectRatio + 0.5 - 0.5 * inputAspectRatio));
              highp float distanceFromSamplePoint = distance(adjustedSamplePos, textureCoordinateToUse);
              lowp vec3 sampledColor = texture2D(inputImageTexture, samplePos).rgb;
              highp float dotScaling = 1.0 - dot(sampledColor, W);
              lowp float checkForPresenceWithinDot = 1.0 - step(distanceFromSamplePoint, (inputFractionalWidthOfPixel * 0.5) * dotScaling);
              gl_FragColor = vec4(vec3(checkForPresenceWithinDot), 1.0);
            }