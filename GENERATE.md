## Generate bunch of filters

### 1. View list of shaders available for processing

```shell
flutter pub run flutter_image_filters
```

### 2. Find filters you need and generate new shader

```shell
flutter pub run flutter_image_filters generate --filters brightness,contrast
```

#### 2.1 Generate shader mixing custom filters
```shell
flutter pub run flutter_image_filters generate --filters brightness,contrast --glsl-root <path_to_custom_shader_sources>
```

### 3. Add new shader file to list of shaders in `pubspec.yaml`
```yaml
# The following section is specific to Flutter packages.
flutter:
  shaders:
    - shaders/brightness_contrast.frag
  uses-material-design: true
  assets:
```

### 4. Create new configuration

```dart
class BrightnessContrastShaderConfiguration extends BunchShaderConfiguration {
  BrightnessContrastShaderConfiguration()
      : super([BrightnessShaderConfiguration(), ContrastShaderConfiguration()]);
}
```

### 5. Register new configuration before using.

**NOTE**: do it once

```dart
void main() {
  FlutterImageFilters.register<BrightnessContrastShaderConfiguration>(() => FragmentProgram.fromAsset('shaders/brightness_contrast.frag'));
  runApp(const MyApp());
}
```
