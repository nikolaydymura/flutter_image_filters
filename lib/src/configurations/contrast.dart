part of '../../flutter_image_filters.dart';

/// Describes contrast manipulations
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

  /// Updates the [contrast] value.
  ///
  /// The [value] must be in 0.0 and 4.0 range.
  set contrast(double value) {
    _contrast.value = value;
    _contrast.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_contrast];
  
  @override
  ShaderConfiguration _createCopyWithCorrectedColors(List<double> correctedColors) {
    // Create a new instance with corrected contrast value
    final corrected = ContrastShaderConfiguration();
    if (correctedColors.isNotEmpty) {
      corrected._contrast.value = correctedColors[0];
      corrected._contrast.update(corrected);
    }
    return corrected;
  }
}
