part of flutter_image_filters;

/// Describes highlight manipulations
class HighlightShadowShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _shadows;
  final NumberParameter _highlights;

  HighlightShadowShaderConfiguration()
      : _shadows = ShaderRangeNumberParameter(
          'inputShadows',
          'shadows',
          0.0,
          0,
          min: 0.0,
          max: 1.0,
        ),
        _highlights = ShaderRangeNumberParameter(
          'inputHighlights',
          'highlights',
          1.0,
          0,
          min: 0.0,
          max: 1.0,
        ),
        super([0.0, 1.0]);

  /// Updates the [shadows] value.
  ///
  /// The [value] must be in 0.0 and 1.0 range.
  set shadows(double value) {
    _shadows.value = value;
    _shadows.update(this);
  }

  /// Updates the [highlights] value.
  ///
  /// The [value] must be in 0.0 and 1.0 range.
  set highlights(double value) {
    _highlights.value = value;
    _highlights.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_shadows, _highlights];
}
