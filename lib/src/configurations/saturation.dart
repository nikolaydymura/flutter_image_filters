part of '../../flutter_image_filters.dart';

/// Describes saturation manipulations
class SaturationShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _saturation;

  SaturationShaderConfiguration()
      : _saturation = ShaderRangeNumberParameter(
          'inputSaturation',
          'saturation',
          1.0,
          0,
          min: 0.0,
          max: 2.0,
        ),
        super([1.0]);

  /// Updates the [saturation] value.
  ///
  /// The [value] must be in 0.0 and 2.0 range.
  set saturation(double value) {
    _saturation.value = value;
    _saturation.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_saturation];
}
