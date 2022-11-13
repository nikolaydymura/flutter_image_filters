part of image_filters;

class GammaShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _gamma;

  GammaShaderConfiguration()
      : _gamma = ShaderSliderNumberParameter(
          'inputGamma',
          'gamma',
          1.2,
          0,
          min: 0.0,
          max: 3.0,
        ),
        super([1.2]);

  set gamma(double value) {
    _gamma.value = value;
    _gamma.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_gamma];
}
