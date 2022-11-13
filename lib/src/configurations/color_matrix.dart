part of flutter_image_filters;

class ColorMatrixShaderConfiguration extends ShaderConfiguration {
  final Matrix4Parameter _colorMatrix;
  final NumberParameter _intensity;

  ColorMatrixShaderConfiguration()
      : _colorMatrix = ShaderMatrix4Parameter(
          'inputColorMatrix',
          'colorMatrix',
          Matrix4.identity(),
          0,
        ),
        _intensity = ShaderNumberParameter(
          'inputIntensity',
          'intensity',
          1.0,
          16,
        ),
        super([...Matrix4.identity().storage, 1.0]);

  set colorMatrix(Matrix4 value) {
    _colorMatrix.value = value;
    _colorMatrix.update(this);
  }

  set intensity(double value) {
    _intensity.value = value;
    _intensity.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_colorMatrix, _intensity];
}
