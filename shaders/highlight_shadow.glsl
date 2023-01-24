#version 320 es

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 3) uniform sampler2D inputImageTexture;
 
layout(location = 0) uniform lowp float inputShadows;
layout(location = 1) uniform lowp float inputHighlights;
layout(location = 2) uniform vec2 screenSize;

const mediump vec3 luminanceWeightingHS = vec3(0.3, 0.3, 0.3);


vec4 processColor(vec4 sourceColor){
    mediump float luminance = dot(sourceColor.rgb, luminanceWeightingHS);

	mediump float shadow = clamp((pow(luminance, 1.0/(inputShadows+1.0)) + (-0.76)*pow(luminance, 2.0/(inputShadows+1.0))) - luminance, 0.0, 1.0);
	mediump float highlight = clamp((1.0 - (pow(1.0-luminance, 1.0/(2.0-inputHighlights)) + (-0.8)*pow(1.0-luminance, 2.0/(2.0-inputHighlights)))) - luminance, -1.0, 0.0);
	lowp vec3 result = vec3(0.0, 0.0, 0.0) + ((luminance + shadow + highlight) - 0.0) * ((sourceColor.rgb - vec3(0.0, 0.0, 0.0))/(luminance - 0.0));

	return vec4(result.rgb, sourceColor.a);
}

void main()
{
	vec2 textureCoordinate = gl_FragCoord.xy / screenSize;
	lowp vec4 textureColor = texture(inputImageTexture, textureCoordinate);

	fragColor = processColor(textureColor);
}