part of '../../flutter_image_filters.dart';

/// Describes vibrance manipulations
class VibranceShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _vibrance;

  VibranceShaderConfiguration()
      : _vibrance = ShaderNumberParameter(
          'inputVibrance',
          'vibrance',
          0.0,
          0,
        ),
        super([0.0]);

  /// Updates the [vibrance] value.
  set vibrance(double value) {
    _vibrance.value = value;
    _vibrance.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_vibrance];
}
