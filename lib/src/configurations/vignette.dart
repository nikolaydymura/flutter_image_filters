part of flutter_image_filters;

class VignetteShaderConfiguration extends ShaderConfiguration {
  final PointParameter _center;
  final ColorParameter _color;
  final NumberParameter _start;
  final NumberParameter _end;

  VignetteShaderConfiguration()
      : _center = _PointParameter(
          'inputVignetteCenter',
          'center',
          const Point<double>(0.0, 0.0),
          0,
        ),
        _color = _ColorParameter(
          'inputVignetteColor',
          'color',
          Colors.black,
          2,
        ),
        _start = _NumberParameter(
          'inputVignetteStart',
          'start',
          0.3,
          5,
        ),
        _end = _NumberParameter('inputVignetteEnd', 'end', 0.75, 6),
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
  List<ConfigurationParameter> get parameters =>
      [_center, _color, _start, _end];
}
