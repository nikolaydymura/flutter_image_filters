//VERTEX_SHADER 

attribute vec4 position;
                    attribute vec4 inputTextureCoordinate;
                    
                    const int GAUSSIAN_SAMPLES = 9;
                    
                    uniform float texelWidthOffset;
                    uniform float texelHeightOffset;
                    
                    varying vec2 textureCoordinate;
                    varying vec2 blurCoordinates[GAUSSIAN_SAMPLES];
                    
                    void main()
                    {
                    	gl_Position = position;
                    	textureCoordinate = inputTextureCoordinate.xy;
                    	
                    	// Calculate the positions for the blur
                    	int multiplier = 0;
                    	vec2 blurStep;
                       vec2 singleStepOffset = vec2(texelHeightOffset, texelWidthOffset);
                        
                    	for (int i = 0; i < GAUSSIAN_SAMPLES; i++)
                       {
                    		multiplier = (i - ((GAUSSIAN_SAMPLES - 1) / 2));
                           // Blur in x (horizontal)
                           blurStep = float(multiplier) * singleStepOffset;
                    		blurCoordinates[i] = inputTextureCoordinate.xy + blurStep;
                    	}
                    }

//FRAGMENT_SHADER 

uniform sampler2D inputImageTexture;
                    
                    const lowp int GAUSSIAN_SAMPLES = 9;
                    
                    varying highp vec2 textureCoordinate;
                    varying highp vec2 blurCoordinates[GAUSSIAN_SAMPLES];
                    
                    void main()
                    {
                    	lowp vec3 sum = vec3(0.0);
                       lowp vec4 fragColor=texture2D(inputImageTexture,textureCoordinate);
                    	
                        sum += texture2D(inputImageTexture, blurCoordinates[0]).rgb * 0.05;
                        sum += texture2D(inputImageTexture, blurCoordinates[1]).rgb * 0.09;
                        sum += texture2D(inputImageTexture, blurCoordinates[2]).rgb * 0.12;
                        sum += texture2D(inputImageTexture, blurCoordinates[3]).rgb * 0.15;
                        sum += texture2D(inputImageTexture, blurCoordinates[4]).rgb * 0.18;
                        sum += texture2D(inputImageTexture, blurCoordinates[5]).rgb * 0.15;
                        sum += texture2D(inputImageTexture, blurCoordinates[6]).rgb * 0.12;
                        sum += texture2D(inputImageTexture, blurCoordinates[7]).rgb * 0.09;
                        sum += texture2D(inputImageTexture, blurCoordinates[8]).rgb * 0.05;
                    
                    	gl_FragColor = vec4(sum,fragColor.a);
                    }
