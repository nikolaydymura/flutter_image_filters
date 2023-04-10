## Define custom configuration

### 1. Add new shader file to list of shaders in `pubspec.yaml`
```yaml
# The following section is specific to Flutter packages.
flutter:
  uses-material-design: true
  shaders:
    - shaders/custom.frag
```

Shader must contain two variables 

```glsl
#include <flutter/runtime_effect.glsl>
layout(location = <last uniform index - 1>) uniform vec2 screenSize;
layout(location = <last uniform index>) uniform lowp sampler2D inputImageTexture; // input image

layout(location = 0) out vec4 fragColor;
```

If you need to allow your function to be part of shader's bunch add `vec4 processColor(vec4 sourceColor)` function

```glsl
vec4 processColor(vec4 sourceColor){
   ...
}

void main() {
    vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
    vec4 textureColor = texture(inputImageTexture, textureCoordinate);

    fragColor = processColor(textureColor);
}
```

### 2. Create class extended from `ShaderConfiguration` and define inputs of filter

| uniform   | Parameter                  | 
|:----------|:---------------------------|
| sampler2D | ShaderTextureParameter     | 
| vec3      | ShaderColorParameter       | 
| mat4      | ShaderMatrix4Parameter     | 
| vec2      | ShaderPointParameter       |
| float     | ShaderRangeNumberParameter |
| float     | ShaderNumberParameter      |
| float     | ShaderIntParameter         |

### 3. Register new configuration before using.

**NOTE**: do it once

```dart
void main() {
  FlutterImageFilters.register<CustomConfiguration>(() => FragmentProgram.fromAsset('shaders/custom.frag'));
  runApp(const MyApp());
}
```

## Example

Let's update `brightness` shader to apple value `*0.2` and save it to `shaders/custom_brightness.frag`

```glsl
#include <flutter/runtime_effect.glsl>
precision mediump float;
layout(location = 0) uniform lowp float inputBrightness;
layout(location = 1) uniform vec2 screenSize;
layout(location = 2) uniform lowp sampler2D inputImageTexture;

layout(location = 0) out vec4 fragColor;

vec4 processColor(vec4 sourceColor){
    return vec4((sourceColor.rgb + vec3(inputBrightness * 0.2 * sourceColor.a)), sourceColor.a);
}

void main() {
    vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
    vec4 textureColor = texture(inputImageTexture, textureCoordinate);

    fragColor = processColor(textureColor);
}
```

```dart

class CustomBrightnessConfiguration extends ShaderConfiguration {
  final NumberParameter _brightness;

  CustomBrightnessConfiguration()
      : _brightness = SahderRangeNumberParameter(
    'inputBrightness', // uniform name
    'brightness', // display name
    0.0,
    0, // default value
    min: -1.0, // minimum value
    max: 1.0, // maximum value
  ),
        super([0.0]); // default values

  // custom setter (optional)
  set brightness(double value) {
    _brightness.value = value;
  }

  // enlist all parameters
  @override
  List<ConfigurationParameter> get parameters => [_brightness];
}
```

```dart
void main() {
  FlutterImageFilters.register<CustomBrightnessConfiguration>(() => FragmentProgram.fromAsset('shaders/custom_brightness.frag'));
  runApp(const MyApp());
}
```