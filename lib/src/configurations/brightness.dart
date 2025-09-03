part of '../../flutter_image_filters.dart';

/// Describes brightness manipulations
class BrightnessShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _brightness;

  BrightnessShaderConfiguration()
      : _brightness = ShaderRangeNumberParameter(
          'inputBrightness',
          'brightness',
          0.0,
          0,
          min: -1.0,
          max: 1.0,
        ),
        super([0.0]);

  /// Updates the [brightness] value.
  ///
  /// The [value] must be in -1.0 and 1.0 range.
  set brightness(double value) {
    _brightness.value = value;
    _brightness.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_brightness];
  
  @override
  ShaderConfiguration _createCopyWithCorrectedColors(List<double> correctedColors) {
    // Create a new instance with corrected brightness value
    final corrected = BrightnessShaderConfiguration();
    if (correctedColors.isNotEmpty) {
      corrected._brightness.value = correctedColors[0];
      corrected._brightness.update(corrected);
    }
    return corrected;
  }
}
