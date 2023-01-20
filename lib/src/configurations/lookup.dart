part of flutter_image_filters;

class SquareLookupTableShaderConfiguration extends ShaderConfiguration {
  final RangeNumberParameter _intensity;
  final DataParameter _cubeData;

  SquareLookupTableShaderConfiguration()
      : _intensity = _RangeNumberParameter(
          'inputIntensity',
          'intensity',
          1.0,
          0,
          min: 0,
          max: 1,
        ),
        _cubeData = TextureParameter('inputTextureCubeData', 'LUT'),
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

class HALDLookupTableShaderConfiguration extends ShaderConfiguration {
  final RangeNumberParameter _intensity;
  final DataParameter _cubeData;

  HALDLookupTableShaderConfiguration()
      : _intensity = _RangeNumberParameter(
          'inputIntensity',
          'intensity',
          1.0,
          0,
          min: 0,
          max: 1,
        ),
        _cubeData = TextureParameter('inputTextureCubeData', 'HALD LUT'),
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
