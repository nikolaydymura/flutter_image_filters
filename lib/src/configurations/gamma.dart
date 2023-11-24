part of flutter_image_filters;

/// Describes manipulation with gamma correction
class GammaShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _gamma;

  GammaShaderConfiguration()
      : _gamma = ShaderRangeNumberParameter(
          'inputGamma',
          'gamma',
          1.2,
          0,
          min: 0.0,
          max: 3.0,
        ),
        super([1.2]);

  /// Updates the [gamma] value.
  ///
  /// The [value] must be in 0.0 and 3.0 range.
  set gamma(double value) {
    _gamma.value = value;
    _gamma.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_gamma];
}
