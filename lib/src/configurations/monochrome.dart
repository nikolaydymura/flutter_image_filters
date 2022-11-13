part of image_filters;

class MonochromeShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _intensity;
  final ColorParameter _color;

  MonochromeShaderConfiguration()
      : _intensity = ShaderSliderNumberParameter(
          'inputIntensity',
          'intensity',
          1.0,
          0,
          min: 0.0,
          max: 1.0,
        ),
        _color = ShaderColorParameter(
          'inputColor',
          'color',
          Color.fromRGBO(
            (0.6 * 255).toInt(),
            (0.45 * 255).toInt(),
            (0.3 * 255).toInt(),
            1.0,
          ),
          1,
        ),
        super([1.0, 0.6, 0.45, 0.3]);

  set intensity(double value) {
    _intensity.value = value;
    _intensity.update(this);
  }

  set color(Color value) {
    _color.value = value;
    _color.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_intensity, _color];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonochromeShaderConfiguration &&
          runtimeType == other.runtimeType &&
          _intensity.value == other._intensity.value &&
          _color.value == other._color.value;

  @override
  int get hashCode => _intensity.value.hashCode ^ _color.value.hashCode;
}
