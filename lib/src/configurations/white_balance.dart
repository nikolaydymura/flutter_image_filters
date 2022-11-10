part of image_filters;

class WhiteBalanceShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _temperature;
  final NumberParameter _tint;

  WhiteBalanceShaderConfiguration()
      : _temperature = NumberParameter(
          'inputTemperature',
          'temperature',
          0,
          5000.0,
        ),
        _tint = NumberParameter(
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
  List<ShaderParameter> get parameters => [_temperature, _tint];
}
