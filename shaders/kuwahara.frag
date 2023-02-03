#include <flutter/runtime_effect.glsl>

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 2) uniform sampler2D inputImageTexture;
layout(location = 0) uniform int inputRadius;
layout(location = 1) uniform vec2 screenSize;

const vec2 src_size = vec2 (1.0 / 768.0, 1.0 / 1024.0);

void main (void) 
{
    vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
    vec2 uv = textureCoordinate;
    float n = float((inputRadius + 1) * (inputRadius + 1));
    int i; int j;
    vec3 m0 = vec3(0.0); vec3 m1 = vec3(0.0); vec3 m2 = vec3(0.0); vec3 m3 = vec3(0.0);
    vec3 s0 = vec3(0.0); vec3 s1 = vec3(0.0); vec3 s2 = vec3(0.0); vec3 s3 = vec3(0.0);
    vec3 c;

    for (j = -inputRadius; j <= 0; ++j)  {
        for (i = -inputRadius; i <= 0; ++i)  {
            c = texture(inputImageTexture, uv + vec2(i,j) * src_size).rgb;
            m0 += c;
            s0 += c * c;
        }
    }

    for (j = -inputRadius; j <= 0; ++j)  {
        for (i = 0; i <= inputRadius; ++i)  {
            c = texture(inputImageTexture, uv + vec2(i,j) * src_size).rgb;
            m1 += c;
            s1 += c * c;
        }
    }

    for (j = 0; j <= inputRadius; ++j)  {
        for (i = 0; i <= inputRadius; ++i)  {
            c = texture(inputImageTexture, uv + vec2(i,j) * src_size).rgb;
            m2 += c;
            s2 += c * c;
        }
    }

    for (j = 0; j <= inputRadius; ++j)  {
        for (i = -inputRadius; i <= 0; ++i)  {
            c = texture(inputImageTexture, uv + vec2(i,j) * src_size).rgb;
            m3 += c;
            s3 += c * c;
        }
    }


    float min_sigma2 = 1e+2;
    m0 /= n;
    s0 = abs(s0 / n - m0 * m0);

    float sigma2 = s0.r + s0.g + s0.b;
    if (sigma2 < min_sigma2) {
        min_sigma2 = sigma2;
        fragColor = vec4(m0, 1.0);
    }

    m1 /= n;
    s1 = abs(s1 / n - m1 * m1);

    sigma2 = s1.r + s1.g + s1.b;
    if (sigma2 < min_sigma2) {
        min_sigma2 = sigma2;
        fragColor = vec4(m1, 1.0);
    }

    m2 /= n;
    s2 = abs(s2 / n - m2 * m2);

    sigma2 = s2.r + s2.g + s2.b;
    if (sigma2 < min_sigma2) {
        min_sigma2 = sigma2;
        fragColor = vec4(m2, 1.0);
    }

    m3 /= n;
    s3 = abs(s3 / n - m3 * m3);

    sigma2 = s3.r + s3.g + s3.b;
    if (sigma2 < min_sigma2) {
        min_sigma2 = sigma2;
        fragColor = vec4(m3, 1.0);
    }
}