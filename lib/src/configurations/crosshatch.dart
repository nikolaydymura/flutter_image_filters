part of flutter_image_filters;

class CrosshatchShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _crossHatchSpacing;
  final NumberParameter _lineWidth;

  CrosshatchShaderConfiguration()
      : _crossHatchSpacing = _NumberParameter(
          'inputCrossHatchSpacing',
          'crossHatchSpacing',
          0.03,
          0,
        ),
        _lineWidth = _NumberParameter(
          'inputLineWidth',
          'lineWidth',
          0.003,
          1,
        ),
        super([0.03, 0.003]);

  set crossHatchSpacing(double value) {
    _crossHatchSpacing.value = value;
    _crossHatchSpacing.update(this);
  }

  set lineWidth(double value) {
    _lineWidth.value = value;
    _lineWidth.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters =>
      [_crossHatchSpacing, _lineWidth];
}
