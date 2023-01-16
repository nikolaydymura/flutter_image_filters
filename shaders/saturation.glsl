#version 320 es

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 2) uniform sampler2D inputImageTexture;
layout(location = 0) uniform float inputSaturation;
layout(location = 1) uniform vec2 screenSize;
            
// Values from \Graphics Shaders: Theory and Practice\ by Bailey and Cunningham
const mediump vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);

vec4 processColor(vec4 sourceColor){
   lowp float luminance = dot(textureColor.rgb, luminanceWeighting);
   lowp vec3 greyScaleColor = vec3(luminance);

   return vec4(mix(greyScaleColor, textureColor.rgb, inputSaturation), textureColor.w);
}

void main()
{
   vec2 textureCoordinate = gl_FragCoord.xy / screenSize;
   lowp vec4 textureColor = texture(inputImageTexture, textureCoordinate);
   
   fragColor = processColor(textureColor);
    
}