part of image_filters;

class MonochromeShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _intensity;
  final ColorParameter _color;

  MonochromeShaderConfiguration()
      : _intensity = NumberParameter('inputIntensity', 'intensity', 0, 1.0),
        _color = ColorParameter(
          'inputColor',
          'color',
          1,
          Color.fromRGBO(
            (0.6 * 255).toInt(),
            (0.45 * 255).toInt(),
            (0.3 * 255).toInt(),
            1.0,
          ),
        ),
        super([1.0, 0.6, 0.45, 0.3]);

  set intensity(double value) {
    _intensity.value = value;
    _intensity.update(this);
  }

  set color(Color value) {
    _color.value = value;
    _color.update(this);
  }

  @override
  List<ShaderParameter> get parameters => [_intensity, _color];
}
