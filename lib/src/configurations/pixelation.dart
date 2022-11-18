part of flutter_image_filters;

class PixelationShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _widthFactor;
  final NumberParameter _heightFactor;
  final NumberParameter _pixel;

  PixelationShaderConfiguration()
      : _widthFactor = _NumberParameter(
          'inputWidthFactor',
          'widthFactor',
          0.005,
          0,
        ),
        _heightFactor = _NumberParameter(
          'inputHeightFactor',
          'heightFactor',
          0.005,
          0,
        ),
        _pixel = _NumberParameter(
          'inputPixel',
          'pixel',
          1.0,
          0,
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
  List<ConfigurationParameter> get parameters =>
      [_widthFactor, _heightFactor, _pixel];
}
