part of image_filters;

class RGBShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _red;
  final NumberParameter _green;
  final NumberParameter _blue;

  RGBShaderConfiguration()
      : _red = SliderNumberParameter(
          'inputRed',
          'red',
          0,
          255.0,
          min: 0.0,
          max: 255.0,
        ),
        _green = SliderNumberParameter(
          'inputGreen',
          'green',
          0,
          255.0,
          min: 0.0,
          max: 255.0,
        ),
        _blue = SliderNumberParameter(
          'inputBlue',
          'blue',
          0,
          255.0,
          min: 0.0,
          max: 255.0,
        ),
        super([1.0, 1.0, 1.0]);

  set red(double value) {
    _red.value = value / 255.0;
    _red.update(this);
  }

  set green(double value) {
    _green.value = value / 255.0;
    _green.update(this);
  }

  set blue(double value) {
    _blue.value = value / 255.0;
    _blue.update(this);
  }

  @override
  List<ShaderParameter> get parameters => [_red, _green, _blue];
}
