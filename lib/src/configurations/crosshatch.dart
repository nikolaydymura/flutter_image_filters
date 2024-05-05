part of '../../flutter_image_filters.dart';

/// Describes crosshatch manipulations
class CrosshatchShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _crossHatchSpacing;
  final NumberParameter _lineWidth;

  CrosshatchShaderConfiguration()
      : _crossHatchSpacing = ShaderNumberParameter(
          'inputCrossHatchSpacing',
          'crossHatchSpacing',
          0.03,
          0,
        ),
        _lineWidth = ShaderNumberParameter(
          'inputLineWidth',
          'lineWidth',
          0.003,
          1,
        ),
        super([0.03, 0.003]);

  /// Updates the [crossHatchSpacing] value.
  set crossHatchSpacing(double value) {
    _crossHatchSpacing.value = value;
    _crossHatchSpacing.update(this);
  }

  /// Updates the [lineWidth] value.
  set lineWidth(double value) {
    _lineWidth.value = value;
    _lineWidth.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters =>
      [_crossHatchSpacing, _lineWidth];
}
