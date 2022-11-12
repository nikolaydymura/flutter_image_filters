part of image_filters;

class HalftoneShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _fractionalWidthOfPixel;
  final AspectRatioParameter _aspectRatio;

  HalftoneShaderConfiguration()
      : _fractionalWidthOfPixel = NumberParameter(
          'inputFractionalWidthOfPixel',
          'fractionalWidthOfPixel',
          0,
          0.01,
        ),
        _aspectRatio = AspectRatioParameter(
          'inputAspectRatio',
          'aspectRatio',
          1,
          const Size(1, 1),
        ),
        super([0.01, 1.0]);

  set fractionalWidthOfPixel(double value) {
    _fractionalWidthOfPixel.value = value;
    _fractionalWidthOfPixel.update(this);
  }

  @override
  List<ShaderParameter> get parameters =>
      [_fractionalWidthOfPixel, _aspectRatio];
}
