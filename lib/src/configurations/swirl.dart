part of image_filters;

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
        _radius = ShaderSliderNumberParameter(
          'inputRadius',
          'radius',
          0.5,
          2,
          min: 0.0,
          max: 1.0,
        ),
        _angle = ShaderSliderNumberParameter(
          'inputAngle',
          'angle',
          1.0,
          3,
          min: 0.0,
          max: 1.0,
        ),
        super([0.5, 0.5, 0.5, 1.0]);

  set center(Point<double> value) {
    _center.value = value;
    _center.update(this);
  }

  set radius(double value) {
    _radius.value = value;
    _radius.update(this);
  }

  set angle(double value) {
    _angle.value = value;
    _angle.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_center, _radius, _angle];
}
