part of flutter_image_filters;

class HalftoneShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _fractionalWidthOfPixel;

  HalftoneShaderConfiguration()
      : _fractionalWidthOfPixel = ShaderNumberParameter(
          'inputFractionalWidthOfPixel',
          'fractionalWidthOfPixel',
          0.01,
          0,
        ),
        _aspectRatio = ShaderAspectRatioParameter(
          'inputAspectRatio',
          'aspectRatio',
          const Size(1, 1),
          1,
        ),
        super([0.01, 1.0]);

  final AspectRatioParameter _aspectRatio;

  set fractionalWidthOfPixel(double value) {
    _fractionalWidthOfPixel.value = value;
    _fractionalWidthOfPixel.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters =>
      [_fractionalWidthOfPixel, _aspectRatio];
}
