part of flutter_image_filters;

class ContrastShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _contrast;

  ContrastShaderConfiguration()
      : _contrast = ShaderRangeNumberParameter(
          'inputContrast',
          'contrast',
          1.2,
          0,
          min: 0.0,
          max: 4.0,
        ),
        super([1.2]);

  set contrast(double value) {
    _contrast.value = value;
    _contrast.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_contrast];
}
