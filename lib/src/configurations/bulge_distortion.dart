part of flutter_image_filters;

class BulgeDistortionShaderConfiguration extends ShaderConfiguration {
  final AspectRatioParameter _aspectRatio;
  final PointParameter _center;
  final RangeNumberParameter _radius;
  final RangeNumberParameter _scale;

  BulgeDistortionShaderConfiguration()
      : _aspectRatio = ShaderAspectRatioParameter(
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
        _radius = ShaderSliderNumberParameter(
          'inputRadius',
          'radius',
          0.25,
          3,
          min: .0,
          max: 1.0,
        ),
        _scale = ShaderSliderNumberParameter(
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

  set center(Point<double> value) {
    _center.value = value;
    _center.update(this);
  }

  set radius(double value) {
    _radius.value = value;
    _radius.update(this);
  }

  set scale(double value) {
    _scale.value = value;
    _scale.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters =>
      [_aspectRatio, _center, _radius, _scale];
}
