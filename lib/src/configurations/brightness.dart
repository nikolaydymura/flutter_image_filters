part of image_filters;

class BrightnessShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _brightness;

  BrightnessShaderConfiguration()
      : _brightness = SliderNumberParameter(
          'inputBrightness',
          'brightness',
          0,
          0.0,
          min: -1.0,
          max: 1.0,
        ),
        super([0.0]);

  set brightness(double value) {
    _brightness.value = value;
    _brightness.update(this);
  }

  @override
  List<ShaderParameter> get parameters => [_brightness];
}
