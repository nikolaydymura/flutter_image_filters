  uniform sampler2D inputImageTexture;
             varying highp vec2 textureCoordinate;
             
             uniform lowp vec2 inputVignetteCenter;
             uniform lowp vec3 inputVignetteColor;
             uniform highp float inputVignetteStart;
             uniform highp float inputVignetteEnd;
             
             void main()
             {
                 /*
                 lowp vec3 rgb = texture2D(inputImageTexture, textureCoordinate).rgb;
                 lowp float d = distance(textureCoordinate, vec2(0.5,0.5));
                 rgb *= (1.0 - smoothstep(inputVignetteStart, inputVignetteEnd, d));
                 gl_FragColor = vec4(vec3(rgb),1.0);
                  */
                 
                 lowp vec3 rgb = texture2D(inputImageTexture, textureCoordinate).rgb;
                 lowp float d = distance(textureCoordinate, vec2(inputVignetteCenter.x, inputVignetteCenter.y));
                 lowp float percent = smoothstep(inputVignetteStart, inputVignetteEnd, d);
                 gl_FragColor = vec4(mix(rgb.x, inputVignetteColor.x, percent), mix(rgb.y, inputVignetteColor.y, percent), mix(rgb.z, inputVignetteColor.z, percent), 1.0);
             }