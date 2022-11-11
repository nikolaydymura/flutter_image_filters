part of image_filters;

class PixelationShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _widthFactor;
  final NumberParameter _heightFactor;
  final NumberParameter _pixel;

  PixelationShaderConfiguration()
      : _widthFactor = NumberParameter(
          'inputWidthFactor',
          'widthFactor',
          0,
          0.005,
        ),
        _heightFactor = NumberParameter(
          'inputHeightFactor',
          'heightFactor',
          0,
          0.005,
        ),
        _pixel = NumberParameter(
          'inputPixel',
          'pixel',
          0,
          1.0,
        ),
        super([0.005, 0.005, 1.0]);

  set widthFactor(double value) {
    _widthFactor.value = value;
    _widthFactor.update(this);
  }

  set heightFactor(double value) {
    _heightFactor.value = value;
    _heightFactor.update(this);
  }

  set pixel(double value) {
    _pixel.value = value;
    _pixel.update(this);
  }

  @override
  List<ShaderParameter> get parameters => [_widthFactor, _heightFactor, _pixel];
}
