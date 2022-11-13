part of image_filters;

class SolarizeShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _threshold;

  SolarizeShaderConfiguration()
      : _threshold = ShaderNumberParameter(
          'inputThreshold',
          'threshold',
          0.5,
          0,
        ),
        super([0.5]);

  set threshold(double value) {
    _threshold.value = value;
    _threshold.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_threshold];
}
