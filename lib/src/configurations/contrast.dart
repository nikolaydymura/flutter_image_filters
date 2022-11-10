part of image_filters;

class ContrastShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _contrast;

  ContrastShaderConfiguration()
      : _contrast = SliderNumberParameter(
          'inputContrast',
          'contrast',
          0,
          1.2,
          min: 0.0,
          max: 4.0,
        ),
        super([1.2]);

  set contrast(double value) {
    _contrast.value = value;
    _contrast.update(this);
  }

  @override
  List<ShaderParameter> get parameters => [_contrast];
}
