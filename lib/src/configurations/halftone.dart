part of image_filters;

class HalftoneShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _fractionalWidthOfPixel;
  final NumberParameter _aspectRatio;

  HalftoneShaderConfiguration()
      : _fractionalWidthOfPixel = NumberParameter(
          'inputFractionalWidthOfPixel',
          'fractionalWidthOfPixel',
          0,
          0.01,
        ),
        _aspectRatio = NumberParameter(
          'inputAspectRatio',
          'aspectRatio',
          1,
          0.67,
        ),
        super([0.01, 0.67]);

  set fractionalWidthOfPixel(double value) {
    _fractionalWidthOfPixel.value = value;
    _fractionalWidthOfPixel.update(this);
  }

  set aspectRatio(double value) {
    _aspectRatio.value = value;
    _aspectRatio.update(this);
  }

  @override
  List<ShaderParameter> get parameters =>
      [_fractionalWidthOfPixel, _aspectRatio];
}
