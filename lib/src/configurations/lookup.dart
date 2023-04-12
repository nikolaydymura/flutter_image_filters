part of flutter_image_filters;

/// Describes square lookup manipulations
class SquareLookupTableShaderConfiguration extends ShaderConfiguration {
  final RangeNumberParameter _intensity;
  final DataParameter _cubeData;

  SquareLookupTableShaderConfiguration()
      : _intensity = ShaderRangeNumberParameter(
          'inputIntensity',
          'intensity',
          1.0,
          0,
          min: 0,
          max: 1,
        ),
        _cubeData = ShaderTextureParameter('inputTextureCubeData', 'LUT'),
        super([1.0]);

  /// Update [_cubeData] value by [setLutImage].
  Future<void> setLutImage(Uint8List value) async {
    _cubeData.data = value;
    _cubeData.asset = null;
    _cubeData.file = null;
    await _cubeData.update(this);
  }

  /// Update [_cubeData] value by [setLutAsset].
  Future<void> setLutAsset(String value) async {
    _cubeData.data = null;
    _cubeData.asset = value;
    _cubeData.file = null;
    await _cubeData.update(this);
  }

  /// Update [_cubeData] value by [setLutFile].
  Future<void> setLutFile(File value) async {
    _cubeData.data = null;
    _cubeData.asset = null;
    _cubeData.file = value;
    await _cubeData.update(this);
  }

  /// Updates the [intensity] value.
  ///
  /// The [value] must be in 0.0 and 1.0 range.
  set intensity(double value) {
    _intensity.value = value;
    _intensity.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_intensity, _cubeData];
}

class HALDLookupTableShaderConfiguration extends ShaderConfiguration {
  final RangeNumberParameter _intensity;
  final DataParameter _cubeData;

  HALDLookupTableShaderConfiguration()
      : _intensity = ShaderRangeNumberParameter(
          'inputIntensity',
          'intensity',
          1.0,
          0,
          min: 0,
          max: 1,
        ),
        _cubeData = ShaderTextureParameter('inputTextureCubeData', 'HALD LUT'),
        super([1.0]);

  Future<void> setLutImage(Uint8List value) async {
    _cubeData.data = value;
    _cubeData.asset = null;
    _cubeData.file = null;
    await _cubeData.update(this);
  }

  Future<void> setLutAsset(String value) async {
    _cubeData.data = null;
    _cubeData.asset = value;
    _cubeData.file = null;
    await _cubeData.update(this);
  }

  Future<void> setLutFile(File value) async {
    _cubeData.data = null;
    _cubeData.asset = null;
    _cubeData.file = value;
    await _cubeData.update(this);
  }

  set intensity(double value) {
    _intensity.value = value;
    _intensity.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_intensity, _cubeData];
}
