part of image_filters;

class WhiteBalanceShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _temperature;
  final NumberParameter _tint;

  WhiteBalanceShaderConfiguration()
      : _temperature = _TemperatureParameter(
          'inputTemperature',
          'temperature',
          0,
          5000.0,
        ),
        _tint = _TintParameter(
          'inputTint',
          'tint',
          1,
          0.0,
        ),
        super([5000.0, 0.0]);

  set temperature(double value) {
    _temperature.value = value;
    _temperature.update(this);
  }

  set tint(double value) {
    _tint.value = value;
    _tint.update(this);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WhiteBalanceShaderConfiguration &&
          runtimeType == other.runtimeType &&
          _temperature == other._temperature &&
          _tint == other._tint;

  @override
  int get hashCode => _temperature.hashCode ^ _tint.hashCode;

  @override
  List<ShaderParameter> get parameters => [_temperature, _tint];
}

class _TemperatureParameter extends NumberParameter {
  _TemperatureParameter(
    super.shaderName,
    super.displayName,
    super.offset,
    super.value,
  );

  @override
  void update(ShaderConfiguration configuration) {
    final temperature = value.toDouble();
    configuration._floats[_offset] = temperature < 5000
        ? 0.0004 * (temperature - 5000.0)
        : 0.00006 * (temperature - 5000.0);
  }
}

class _TintParameter extends NumberParameter {
  _TintParameter(
      super.shaderName,
      super.displayName,
      super.offset,
      super.value,
      );

  @override
  void update(ShaderConfiguration configuration) {
    configuration._floats[_offset] = value.toDouble() / 100.0;
  }
}
