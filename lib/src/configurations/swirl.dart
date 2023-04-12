part of flutter_image_filters;

/// Describes swirl manipulations
class SwirlShaderConfiguration extends ShaderConfiguration {
  final PointParameter _center;
  final NumberParameter _radius;
  final NumberParameter _angle;

  SwirlShaderConfiguration()
      : _center = ShaderPointParameter(
          'inputCenter',
          'center',
          const Point<double>(0.5, 0.5),
          0,
        ),
        _radius = ShaderRangeNumberParameter(
          'inputRadius',
          'radius',
          0.5,
          2,
          min: 0.0,
          max: 1.0,
        ),
        _angle = ShaderRangeNumberParameter(
          'inputAngle',
          'angle',
          1.0,
          3,
          min: 0.0,
          max: 1.0,
        ),
        super([0.5, 0.5, 0.5, 1.0]);

  /// Updates the [center] value.
  set center(Point<double> value) {
    _center.value = value;
    _center.update(this);
  }

  /// Updates the [radius] value.
  ///
  /// The [value] must be in 0.0 and 1.0 range.
  set radius(double value) {
    _radius.value = value;
    _radius.update(this);
  }

  /// Updates the [angle] value.
  ///
  /// The [value] must be in 0.0 and 1.0 range.
  set angle(double value) {
    _angle.value = value;
    _angle.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_center, _radius, _angle];
}
