part of '../../flutter_image_filters.dart';

/// Describes posterize manipulations
class PosterizeShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _colorLevels;

  PosterizeShaderConfiguration()
      : _colorLevels = _IntSliderParameter(
          'inputColorLevels',
          'colorLevels',
          10.0,
          0,
          min: 1.0,
          max: 256.0,
        ),
        super([10.0]);

  /// Updates the [colorLevels] value.
  ///
  /// The [value] must be in 1.0 and 256.0 range.
  set colorLevels(double value) {
    _colorLevels.value = value;
    _colorLevels.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_colorLevels];
}

class _IntSliderParameter extends ShaderRangeNumberParameter {
  _IntSliderParameter(
    super.shaderName,
    super.displayName,
    super.value,
    super.offset, {
    super.min,
    super.max,
  });

  @override
  void update(ShaderConfiguration configuration) {
    configuration._floats[_offset] = value.toInt().toDouble();
  }
}
