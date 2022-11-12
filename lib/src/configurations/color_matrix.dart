part of image_filters;

class ColorMatrixShaderConfiguration extends ShaderConfiguration {
  final Matrix4Parameter _colorMatrix;
  final NumberParameter _intensity;

  ColorMatrixShaderConfiguration()
      : _colorMatrix = Matrix4Parameter(
          'inputColorMatrix',
          'colorMatrix',
          0,
          Matrix4.identity(),
        ),
        _intensity = NumberParameter(
          'inputIntensity',
          'intensity',
          16,
          1.0,
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
  List<ShaderParameter> get parameters => [_colorMatrix, _intensity];
}
