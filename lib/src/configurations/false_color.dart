part of flutter_image_filters;

class FalseColorShaderConfiguration extends ShaderConfiguration {
  final ColorParameter _firstColor;
  final ColorParameter _secondColor;

  FalseColorShaderConfiguration()
      : _firstColor = _ColorParameter(
          'inputFirstColor',
          'firstColor',
          Color.fromRGBO(0, 0, (0.5 * 255).toInt(), 1.0),
          0,
        ),
        _secondColor = _ColorParameter(
          'inputSecondColor',
          'secondColor',
          const Color.fromRGBO(255, 0, 0, 1.0),
          3,
        ),
        super([0.0, 0.0, 0.5, 1.0, 0.0, 0.0]);

  set firstColor(Color value) {
    _firstColor.value = value;
    _firstColor.update(this);
  }

  set secondColor(Color value) {
    _secondColor.value = value;
    _secondColor.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_firstColor, _secondColor];
}
