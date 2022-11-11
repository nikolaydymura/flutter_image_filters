part of image_filters;

class SwirlShaderConfiguration extends ShaderConfiguration {
  final PointParameter _center;
  final NumberParameter _radius;
  final NumberParameter _angle;

  SwirlShaderConfiguration()
      : _center = PointParameter(
          'inputCenter',
          'center',
          0,
          const Point<double>(0.5, 0.5),
        ),
        _radius = SliderNumberParameter(
          'inputRadius',
          'radius',
          2,
          0.5,
          min: 0.0,
          max: 1.0,
        ),
        _angle = SliderNumberParameter(
          'inputAngle',
          'angle',
          3,
          1.0,
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
  List<ShaderParameter> get parameters => [_center, _radius, _angle];
}
