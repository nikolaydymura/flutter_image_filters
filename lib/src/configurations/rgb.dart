part of flutter_image_filters;

class RGBShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _red;
  final NumberParameter _green;
  final NumberParameter _blue;

  RGBShaderConfiguration()
      : _red = _ColorIntensityParameter(
          'inputRed',
          'red',
          255.0,
          0,
          min: 0.0,
          max: 255.0,
        ),
        _green = _ColorIntensityParameter(
          'inputGreen',
          'green',
          255.0,
          1,
          min: 0.0,
          max: 255.0,
        ),
        _blue = _ColorIntensityParameter(
          'inputBlue',
          'blue',
          255.0,
          2,
          min: 0.0,
          max: 255.0,
        ),
        super([1.0, 1.0, 1.0]);

  set red(double value) {
    _red.value = value;
    _red.update(this);
  }

  set green(double value) {
    _green.value = value;
    _green.update(this);
  }

  set blue(double value) {
    _blue.value = value;
    _blue.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_red, _green, _blue];
}

class _ColorIntensityParameter extends _RangeNumberParameter {
  _ColorIntensityParameter(
    super.shaderName,
    super.displayName,
    super.value,
    super.offset, {
    super.min,
    super.max,
  });

  @override
  void update(ShaderConfiguration configuration) {
    configuration._floats[_offset] = value.toDouble() / 255.0;
  }
}
