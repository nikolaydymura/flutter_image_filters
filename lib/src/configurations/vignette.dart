part of image_filters;

class VignetteShaderConfiguration extends ShaderConfiguration {
  final PointParameter _center;
  final ColorParameter _color;
  final NumberParameter _start;
  final NumberParameter _end;

  VignetteShaderConfiguration()
      : _center = PointParameter(
          'inputVignetteCenter',
          'center',
          0,
          const Point<double>(0.0, 0.0),
        ),
        _color = ColorParameter(
          'inputVignetteColor',
          'color',
          2,
          Colors.black,
        ),
        _start = NumberParameter('inputVignetteStart', 'start', 5, 0.3),
        _end = NumberParameter('inputVignetteEnd', 'end', 6, 0.75),
        super([
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.3,
          0.75,
        ]);

  set center(Point<double> value) {
    _center.value = value;
    _center.update(this);
  }

  set color(Color value) {
    _color.value = value;
    _color.update(this);
  }

  set start(double value) {
    _start.value = value;
    _start.update(this);
  }

  set end(double value) {
    _end.value = value;
    _end.update(this);
  }

  @override
  List<ShaderParameter> get parameters => [_center, _color, _start, _end];
}
