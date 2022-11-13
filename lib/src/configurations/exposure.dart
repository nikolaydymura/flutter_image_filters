part of flutter_image_filters;

class ExposureShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _exposure;

  ExposureShaderConfiguration()
      : _exposure = ShaderSliderNumberParameter(
          'inputExposure',
          'exposure',
          1.0,
          0,
          min: -10.0,
          max: 10.0,
        ),
        super([1.0]);

  set exposure(double value) {
    _exposure.value = value;
    _exposure.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_exposure];
}
