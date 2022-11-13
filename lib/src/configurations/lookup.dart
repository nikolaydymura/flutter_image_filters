part of image_filters;

class LookupTableShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _intensity;
  final NumberParameter _size;
  final NumberParameter _rows;
  final NumberParameter _columns;

  LookupTableShaderConfiguration()
      : _intensity = ShaderNumberParameter(
          'inputIntensity',
          'intensity',
          1.0,
          0,
        ),
        _size = ShaderNumberParameter('inputSize', 'size', 8.0, 1),
        _rows = ShaderNumberParameter('inputRows', 'rows', 8.0, 2),
        _columns = ShaderNumberParameter('inputColumns', 'columns', 8.0, 3),
        super([1.0, 8.0, 8.0, 8.0]);

  LookupTableShaderConfiguration.size8x64()
      : _intensity = ShaderNumberParameter(
          'inputIntensity',
          'intensity',
          1.0,
          0,
        ),
        _size = ShaderNumberParameter(
          'inputSize',
          'size',
          8.0,
          1,
        ),
        _rows = ShaderNumberParameter(
          'inputRows',
          'rows',
          64.0,
          2,
        ),
        _columns = ShaderNumberParameter('inputColumns', 'columns', 8.0, 3),
        super([1.0, 8.0, 64.0, 8.0]);

  LookupTableShaderConfiguration.size16x1()
      : _intensity =
            ShaderNumberParameter('inputIntensity', 'intensity', 1.0, 0),
        _size = ShaderNumberParameter('inputSize', 'size', 16.0, 1),
        _rows = ShaderNumberParameter('inputRows', 'rows', 1.0, 2),
        _columns = ShaderNumberParameter('inputColumns', 'columns', 16.0, 3),
        super([1.0, 16.0, 1.0, 16.0]);

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
      [_intensity, _size, _rows, _columns];
}
