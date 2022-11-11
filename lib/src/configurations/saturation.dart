part of image_filters;

class SaturationShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _saturation;

  SaturationShaderConfiguration()
      : _saturation = SliderNumberParameter(
          'inputSaturation',
          'saturation',
          0,
          1.0,
          min: 0.0,
          max: 2.0,
        ),
        super([1.0]);

  set saturation(double value) {
    _saturation.value = value;
    _saturation.update(this);
  }

  @override
  List<ShaderParameter> get parameters => [_saturation];
}
