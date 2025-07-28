## Generate bunch of filters

### 1. Define a configuration for bunch of shaders

```dart
@BunchShaderConfigs(
  configs: [
    BunchShaderConfig(
      shaders: [BrightnessShaderConfiguration, ContrastShaderConfiguration],
    ),
  ],
)
```

### 2. Register all new configurations at app launch

```dart
void main() {
  registerBunchShaders();
  runApp(const MyApp());
}
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
