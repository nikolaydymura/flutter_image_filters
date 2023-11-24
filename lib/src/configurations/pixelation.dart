part of flutter_image_filters;

/// Describes pixelation manipulations
class PixelationShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _widthFactor;
  final NumberParameter _heightFactor;
  final NumberParameter _pixel;

  PixelationShaderConfiguration()
      : _widthFactor = ShaderNumberParameter(
          'inputWidthFactor',
          'widthFactor',
          0.005,
          0,
        ),
        _heightFactor = ShaderNumberParameter(
          'inputHeightFactor',
          'heightFactor',
          0.005,
          0,
        ),
        _pixel = ShaderNumberParameter(
          'inputPixel',
          'pixel',
          1.0,
          0,
        ),
        super([0.005, 0.005, 1.0]);

  /// Updates the [widthFactor] value.
  set widthFactor(double value) {
    _widthFactor.value = value;
    _widthFactor.update(this);
  }

  /// Updates the [heightFactor] value.
  set heightFactor(double value) {
    _heightFactor.value = value;
    _heightFactor.update(this);
  }

  /// Updates the [pixel] value.
  set pixel(double value) {
    _pixel.value = value;
    _pixel.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters =>
      [_widthFactor, _heightFactor, _pixel];
}
