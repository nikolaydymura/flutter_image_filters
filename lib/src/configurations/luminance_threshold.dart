part of image_filters;

class LuminanceThresholdShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _threshold;

  LuminanceThresholdShaderConfiguration()
      : _threshold = NumberParameter(
          'inputThreshold',
          'threshold',
          0,
          0.5,
        ),
        super([0.5]);

  set threshold(double value) {
    _threshold.value = value;
    _threshold.update(this);
  }

  @override
  List<ShaderParameter> get parameters => [_threshold];
}