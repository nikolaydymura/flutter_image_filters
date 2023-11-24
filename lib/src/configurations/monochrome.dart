part of flutter_image_filters;

/// Describes monochrome manipulations
class MonochromeShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _intensity;
  final ColorParameter _color;

  MonochromeShaderConfiguration()
      : _intensity = ShaderRangeNumberParameter(
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

  /// Updates the [intensity] value.
  ///
  /// The [value] must be in 0.0 and 1.0 range.
  set intensity(double value) {
    _intensity.value = value;
    _intensity.update(this);
  }

  /// Updates the [color] value.
  ///
  /// The [value] must be three channels each in the range 0.0 to 255.0.
  set color(Color value) {
    _color.value = value;
    _color.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_intensity, _color];
}
