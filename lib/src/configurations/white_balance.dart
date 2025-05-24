part of '../../flutter_image_filters.dart';

/// Describes white balance manipulations
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

  /// Updates the [temperature] value.
  set temperature(double value) {
    _temperature.value = value;
    _temperature.update(this);
  }

  /// Updates the [tint] value.
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
    if (configuration is BunchShaderConfiguration) {
      final conf = findByParameter(configuration);
      if (conf != null) {
        update(conf);
      }
    } else {
      final temperature = value.toDouble();
      configuration._floats[_offset] = temperature < 5000
          ? 0.0004 * (temperature - 5000.0)
          : 0.00006 * (temperature - 5000.0);
      configuration._needRedraw = true;
    }
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
    if (configuration is BunchShaderConfiguration) {
      final conf = findByParameter(configuration);
      if (conf != null) {
        update(conf);
      }
    } else {
      configuration._floats[_offset] = value.toDouble() / 100.0;
      configuration._needRedraw = true;
    }
  }
}
