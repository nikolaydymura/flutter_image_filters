part of flutter_image_filters;

class LookupTableShaderConfiguration extends ShaderConfiguration {
  final RangeNumberParameter _intensity;
  final NumberParameter _size;
  final NumberParameter _rows;
  final NumberParameter _columns;
  final DataParameter _cubeData;

  LookupTableShaderConfiguration()
      : _intensity = _RangeNumberParameter(
          'inputIntensity',
          'intensity',
          1.0,
          0,
          min: 0,
          max: 1,
        ),
        _size = _NumberParameter('inputSize', 'size', 8.0, 1),
        _rows = _NumberParameter('inputRows', 'rows', 8.0, 2),
        _columns = _NumberParameter('inputColumns', 'columns', 8.0, 3),
        _cubeData = TextureParameter('inputTextureCubeData', 'LUT'),
        super([1.0, 8.0, 8.0, 8.0]);

  LookupTableShaderConfiguration.size8x64()
      : _intensity = _RangeNumberParameter(
          'inputIntensity',
          'intensity',
          1.0,
          0,
          min: 0,
          max: 1,
        ),
        _size = _NumberParameter(
          'inputSize',
          'size',
          8.0,
          1,
        ),
        _rows = _NumberParameter(
          'inputRows',
          'rows',
          64.0,
          2,
        ),
        _columns = _NumberParameter('inputColumns', 'columns', 8.0, 3),
        _cubeData = TextureParameter('inputTextureCubeData', 'LUT'),
        super([1.0, 8.0, 64.0, 8.0]);

  LookupTableShaderConfiguration.size16x1()
      : _intensity = _RangeNumberParameter(
          'inputIntensity',
          'intensity',
          1.0,
          0,
          min: 0,
          max: 1,
        ),
        _size = _NumberParameter('inputSize', 'size', 16.0, 1),
        _rows = _NumberParameter('inputRows', 'rows', 1.0, 2),
        _columns = _NumberParameter('inputColumns', 'columns', 16.0, 3),
        _cubeData = TextureParameter('inputTextureCubeData', 'LUT'),
        super([1.0, 16.0, 1.0, 16.0]);

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

  set size(double value) {
    _size.value = value;
    _size.update(this);
  }

  set rows(double value) {
    _rows.value = value;
    _rows.update(this);
  }

  set columns(double value) {
    _columns.value = value;
    _columns.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters =>
      [_intensity, _size, _rows, _columns, _cubeData];
}
