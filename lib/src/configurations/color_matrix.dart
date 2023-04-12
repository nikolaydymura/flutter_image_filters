part of flutter_image_filters;

///Describes color changes using the values of a 4x4 matrix
class ColorMatrixShaderConfiguration extends ShaderConfiguration {
  final Mat4Parameter _colorMatrix;
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


  /// Updates the [colorMatrix] value.
  set colorMatrix(Matrix4 value) {
    _colorMatrix.value = value;
    _colorMatrix.update(this);
  }

  /// Updates the [intensity] value.
  set intensity(double value) {
    _intensity.value = value;
    _intensity.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_colorMatrix, _intensity];
}
