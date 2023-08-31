#include <flutter/runtime_effect.glsl>

precision highp float;

out vec4 fragColor;

uniform sampler2D inputImageTexture;

layout(location = 0) uniform highp vec2 inputCenter;
layout(location = 1) uniform highp float inputRadius;
layout(location = 2) uniform highp float inputAspectRatio;
layout(location = 3) uniform highp float inputRefractiveIndex;
layout(location = 4) uniform vec2 screenSize;

const highp vec3 lightPosition = vec3(-0.5, 0.5, 1.0);
const highp vec3 ambientLightPosition = vec3(0.0, 0.0, 1.0);

void main()
{
    vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
    highp vec2 textureCoordinateToUse = vec2(textureCoordinate.x, (textureCoordinate.y * inputAspectRatio + 0.5 - 0.5 * inputAspectRatio));
    highp float distanceFrominputCenter = distance(inputCenter, textureCoordinateToUse);
    lowp float checkForPresenceWithinSphere = step(distanceFrominputCenter, inputRadius);

    distanceFrominputCenter = distanceFrominputCenter / inputRadius;

    highp float normalizedDepth = inputRadius * sqrt(1.0 - distanceFrominputCenter * distanceFrominputCenter);
    highp vec3 sphereNormal = normalize(vec3(textureCoordinateToUse - inputCenter, normalizedDepth));

    highp vec3 refractedVector = 2.0 * refract(vec3(0.0, 0.0, -1.0), sphereNormal, inputRefractiveIndex);
    refractedVector.xy = -refractedVector.xy;

    highp vec3 finalSphereColor = texture(inputImageTexture, (refractedVector.xy + 1.0) * 0.5).rgb;

    // Grazing angle lighting
    highp float lightingIntensity = 2.5 * (1.0 - pow(clamp(dot(ambientLightPosition, sphereNormal), 0.0, 1.0), 0.25));
    finalSphereColor += lightingIntensity;

    // Specular lighting
    lightingIntensity  = clamp(dot(normalize(lightPosition), sphereNormal), 0.0, 1.0);
    lightingIntensity  = pow(lightingIntensity, 15.0);
    finalSphereColor += vec3(0.8, 0.8, 0.8) * lightingIntensity;

    fragColor = vec4(finalSphereColor, 1.0) * checkForPresenceWithinSphere;
}