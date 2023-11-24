part of flutter_image_filters;

/// Describes bulge distortion manipulations
class BulgeDistortionShaderConfiguration extends ShaderConfiguration {
  final AspectRatioParameter _aspectRatio;
  final PointParameter _center;
  final RangeNumberParameter _radius;
  final RangeNumberParameter _scale;

  BulgeDistortionShaderConfiguration()
      : _aspectRatio = _AspectRatioParameter(
          'inputAspectRatio',
          'aspectRatio',
          const Size(1, 1),
          0,
        ),
        _center = ShaderPointParameter(
          'inputCenter',
          'center',
          const Point<double>(0.5, 0.5),
          1,
        ),
        _radius = ShaderRangeNumberParameter(
          'inputRadius',
          'radius',
          0.25,
          3,
          min: .0,
          max: 1.0,
        ),
        _scale = ShaderRangeNumberParameter(
          'inputScale',
          'scale',
          0.5,
          4,
          min: -1.0,
          max: 1.0,
        ),
        super([
          1.0,
          0.5,
          0.5,
          0.25,
          0.5,
        ]);

  /// Updates the [center] value.
  set center(Point<double> value) {
    _center.value = value;
    _center.update(this);
  }

  /// Updates the [radius] value.
  ///
  /// The [value] must be in .0 and 1.0 range.
  set radius(double value) {
    _radius.value = value;
    _radius.update(this);
  }

  /// Updates the [scale] value.
  ///
  /// The [value] must be in -1.0 and 1.0 range.
  set scale(double value) {
    _scale.value = value;
    _scale.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters =>
      [_aspectRatio, _center, _radius, _scale];
}
