part of flutter_image_filters;

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
