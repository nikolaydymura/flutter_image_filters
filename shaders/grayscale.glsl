#version 320 es

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 1) uniform sampler2D inputImageTexture;
layout(location = 0) uniform vec2 screenSize;

const highp vec3 W = vec3(0.2125, 0.7154, 0.0721);

vec4 processColor(vec4 sourceColor){
    float luminance = dot(sourceColor.rgb, W);

    return vec4(vec3(luminance), sourceColor.a);
}

void main(){
  vec2 textureCoordinate = gl_FragCoord.xy / screenSize;
  lowp vec4 sourceColor = texture(inputImageTexture, textureCoordinate);

  fragColor = processColor(sourceColor);
}