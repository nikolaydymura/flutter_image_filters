part of image_filters;

class RGBShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _red;
  final NumberParameter _green;
  final NumberParameter _blue;

  RGBShaderConfiguration()
      : _red = _ColorIntensityParameter(
          'inputRed',
          'red',
          0,
          255.0,
          min: 0.0,
          max: 255.0,
        ),
        _green = _ColorIntensityParameter(
          'inputGreen',
          'green',
          1,
          255.0,
          min: 0.0,
          max: 255.0,
        ),
        _blue = _ColorIntensityParameter(
          'inputBlue',
          'blue',
          2,
          255.0,
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
  List<ShaderParameter> get parameters => [_red, _green, _blue];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RGBShaderConfiguration &&
          runtimeType == other.runtimeType &&
          _red == other._red &&
          _green == other._green &&
          _blue == other._blue;

  @override
  int get hashCode => _red.hashCode ^ _green.hashCode ^ _blue.hashCode;
}

class _ColorIntensityParameter extends SliderNumberParameter {
  _ColorIntensityParameter(
    super.shaderName,
    super.displayName,
    super.offset,
    super.value, {
    super.min,
    super.max,
  });

  @override
  void update(ShaderConfiguration configuration) {
    configuration._floats[_offset] = value.toDouble() / 255.0;
  }
}
