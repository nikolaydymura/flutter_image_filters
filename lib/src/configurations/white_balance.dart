part of flutter_image_filters;

class WhiteBalanceShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _temperature;
  final NumberParameter _tint;

  WhiteBalanceShaderConfiguration()
      : _temperature = _TemperatureParameter(
          'inputTemperature',
          'temperature',
          5000.0,
          0,
        ),
        _tint = _TintParameter(
          'inputTint',
          'tint',
          0.0,
          1,
        ),
        super([0.0, 0.0]);

  set temperature(double value) {
    _temperature.value = value;
    _temperature.update(this);
  }

  set tint(double value) {
    _tint.value = value;
    _tint.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_temperature, _tint];
}

class _TemperatureParameter extends ShaderNumberParameter {
  _TemperatureParameter(
    super.name,
    super.displayName,
    super.value,
    super.offset,
  );

  @override
  void update(ShaderConfiguration configuration) {
    final temperature = value.toDouble();
    configuration._floats[_offset] = temperature < 5000
        ? 0.0004 * (temperature - 5000.0)
        : 0.00006 * (temperature - 5000.0);
  }
}

class _TintParameter extends ShaderNumberParameter {
  _TintParameter(
    super.shaderName,
    super.displayName,
    super.value,
    super.offset,
  );

  @override
  void update(ShaderConfiguration configuration) {
    configuration._floats[_offset] = value.toDouble() / 100.0;
  }
}
