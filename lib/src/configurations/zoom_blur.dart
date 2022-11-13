part of image_filters;

class ZoomBlurShaderConfiguration extends ShaderConfiguration {
  final PointParameter _center;
  final NumberParameter _size;

  ZoomBlurShaderConfiguration()
      : _center = ShaderPointParameter(
          'inputBlurCenter',
          'center',
          const Point<double>(0.5, 0.5),
          0,
        ),
        _size = ShaderNumberParameter(
          'inputBlurSize',
          'size',
          1.0,
          2,
        ),
        super([0.5, 0.5, 1.0]);

  set center(Point<double> value) {
    _center.value = value;
    _center.update(this);
  }

  set size(double value) {
    _size.value = value;
    _size.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_center, _size];
}
