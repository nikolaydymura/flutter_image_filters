part of image_filters;

class PosterizeShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _colorLevels;

  PosterizeShaderConfiguration()
      : _colorLevels = SliderNumberParameter(
          'inputColorLevels',
          'colorLevels',
          0,
          10.0,
          min: 1.0,
          max: 256.0,
        ),
        super([10.0]);

  set colorLevels(double value) {
    _colorLevels.value = value;
    _colorLevels.update(this);
  }

  @override
  List<ShaderParameter> get parameters => [_colorLevels];
}
