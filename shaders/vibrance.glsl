#version 320 es

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 2) uniform sampler2D inputImageTexture;
layout(location = 0) uniform lowp float inputVibrance;
layout(location = 1) uniform vec2 screenSize;

void main() {
    vec2 textureCoordinate = gl_FragCoord.xy / screenSize;
    lowp vec4 color = texture(inputImageTexture, textureCoordinate);
    lowp float average = (color.r + color.g + color.b) / 3.0;
    lowp float mx = max(color.r, max(color.g, color.b));
    lowp float amt = (mx - average) * (-inputVibrance * 3.0);
    color.rgb = mix(color.rgb, vec3(mx), amt);
    fragColor = color;
}