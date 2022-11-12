part of image_filters;

class CrosshatchShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _crossHatchSpacing;
  final NumberParameter _lineWidth;

  CrosshatchShaderConfiguration()
      : _crossHatchSpacing = NumberParameter(
          'inputCrossHatchSpacing',
          'crossHatchSpacing',
          0,
          0.03,
        ),
        _lineWidth = NumberParameter(
          'inputLineWidth',
          'lineWidth',
          1,
          0.003,
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
  List<ShaderParameter> get parameters => [_crossHatchSpacing, _lineWidth];
}
