part of '../../flutter_image_filters.dart';

/// Describes zoom blur manipulations
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

  /// Updates the [center] value.
  set center(Point<double> value) {
    _center.value = value;
    _center.update(this);
  }

  /// Updates the [size] value.
  set size(double value) {
    _size.value = value;
    _size.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_center, _size];
}
