## Generate bunch of filters

### 1. View list of shaders available for processing

```shell
flutter pub run flutter_image_filters
```

### 2. Find filters you need and generate and compile new shader

```shell
flutter pub run flutter_image_filters generate --filters brightness,contrast
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
