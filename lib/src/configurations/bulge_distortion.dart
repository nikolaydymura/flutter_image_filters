part of image_filters;

class BulgeDistortionShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _aspectRatio;
  final PointParameter _center;
  final NumberParameter _radius;
  final NumberParameter _scale;

  BulgeDistortionShaderConfiguration()
      : _aspectRatio = NumberParameter(
          'inputAspectRatio',
          'aspectRatio',
          0,
          0.67,
        ),
        _center = PointParameter(
          'inputCenter',
          'center',
          1,
          const Point<double>(0.5, 0.5),
        ),
        _radius = SliderNumberParameter(
          'inputRadius',
          'radius',
          3,
          0.25,
          min: .0,
          max: 1.0,
        ),
        _scale = SliderNumberParameter(
          'inputScale',
          'scale',
          4,
          0.5,
          min: -1.0,
          max: 1.0,
        ),
        super([
          0.67,
          0.5,
          0.5,
          0.25,
          0.5,
        ]);

  set aspectRatio(double value) {
    _aspectRatio.value = value;
    _aspectRatio.update(this);
  }

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
  List<ShaderParameter> get parameters =>
      [_aspectRatio, _center, _radius, _scale];
}
