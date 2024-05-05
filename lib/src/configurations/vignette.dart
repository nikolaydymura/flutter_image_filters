part of '../../flutter_image_filters.dart';

/// Describes vignette manipulations
class VignetteShaderConfiguration extends ShaderConfiguration {
  final PointParameter _center;
  final ColorParameter _color;
  final NumberParameter _start;
  final NumberParameter _end;

  VignetteShaderConfiguration()
      : _center = ShaderPointParameter(
          'inputVignetteCenter',
          'center',
          const Point<double>(0.0, 0.0),
          0,
        ),
        _color = ShaderColorParameter(
          'inputVignetteColor',
          'color',
          Colors.black,
          2,
        ),
        _start = ShaderNumberParameter(
          'inputVignetteStart',
          'start',
          0.3,
          5,
        ),
        _end = ShaderNumberParameter('inputVignetteEnd', 'end', 0.75, 6),
        super([
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.3,
          0.75,
        ]);

  /// Updates the [center] value.
  set center(Point<double> value) {
    _center.value = value;
    _center.update(this);
  }

  /// Updates the [color] value.
  set color(Color value) {
    _color.value = value;
    _color.update(this);
  }

  /// Updates the [start] value.
  set start(double value) {
    _start.value = value;
    _start.update(this);
  }

  /// Updates the [end] value.
  set end(double value) {
    _end.value = value;
    _end.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters =>
      [_center, _color, _start, _end];
}
