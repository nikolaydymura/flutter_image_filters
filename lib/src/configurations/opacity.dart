part of '../../flutter_image_filters.dart';

/// Describes opacity manipulations
class OpacityShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _opacity;

  OpacityShaderConfiguration()
      : _opacity = ShaderRangeNumberParameter(
          'inputOpacity',
          'opacity',
          1.0,
          0,
          min: .0,
          max: 1.0,
        ),
        super([1.0]);

  /// Updates the [opacity] value.
  ///
  /// The [value] must be in 0.0 and 1.0 range.
  set opacity(double value) {
    _opacity.value = value;
    _opacity.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_opacity];
}
