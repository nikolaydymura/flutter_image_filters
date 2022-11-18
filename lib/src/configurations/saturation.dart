part of flutter_image_filters;

class SaturationShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _saturation;

  SaturationShaderConfiguration()
      : _saturation = _RangeNumberParameter(
          'inputSaturation',
          'saturation',
          1.0,
          0,
          min: 0.0,
          max: 2.0,
        ),
        super([1.0]);

  set saturation(double value) {
    _saturation.value = value;
    _saturation.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_saturation];
}
