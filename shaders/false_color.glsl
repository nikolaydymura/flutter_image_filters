precision lowp float;
            
            varying highp vec2 textureCoordinate;
            
            uniform sampler2D inputImageTexture;
            uniform float intensity;

            uniform vec3 inputFirstColor;
            uniform vec3 inputSecondColor;
            
            const mediump vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);
            
            void main()
            {
            lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
            float luminance = dot(textureColor.rgb, luminanceWeighting);
            
            gl_FragColor = vec4( mix(inputFirstColor.rgb, inputSecondColor.rgb, luminance), textureColor.a);
            }