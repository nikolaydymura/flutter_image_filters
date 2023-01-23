## Generate bunch of filters

### 1. Install shader dependency into project

```shell
flutter pub add -d shader
```
### 2. Download and extract GLSL sources of shaders

### 3. View list of shaders available for processing

```shell
flutter pub run flutter_image_filters
```

### 4. Find filters you need and generate and compile new shader

```shell
flutter pub run flutter_image_filters generate --glsl-root downloaded/shaders --filters brightness,contrast
```

### 5. Copy new file into `lib` directory

![BrightnessContrastBunch](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/doc/images/bunch_brightness_contrast.png)

### 6. Create new configuration

```dart
class BrightnessContrastShaderConfiguration extends BunchShaderConfiguration {
  BrightnessContrastShaderConfiguration()
      : super([BrightnessShaderConfiguration(), ContrastShaderConfiguration()]);
}
```

### 7. Register new configuration before using.

**NOTE**: do it once

```dart
void main() {
  FlutterImageFilters.register<BrightnessContrastShaderConfiguration>(() => brightnessContrastFragmentProgram());
  runApp(const MyApp());
}
```
