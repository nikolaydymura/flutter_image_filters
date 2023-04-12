part of flutter_image_filters;

/// Describes exposure manipulations
class ExposureShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _exposure;

  ExposureShaderConfiguration()
      : _exposure = ShaderRangeNumberParameter(
          'inputExposure',
          'exposure',
          1.0,
          0,
          min: -10.0,
          max: 10.0,
        ),
        super([1.0]);

  /// Updates the [exposure] value.
  ///
  /// The [value] must be in -10.0 and 10.0 range.
  set exposure(double value) {
    _exposure.value = value;
    _exposure.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_exposure];
}
