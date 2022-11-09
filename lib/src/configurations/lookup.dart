part of image_filters;

class LookupTableShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _intensity;
  final NumberParameter _size;
  final NumberParameter _rows;
  final NumberParameter _columns;

  LookupTableShaderConfiguration()
      : _intensity = NumberParameter('inputIntensity', 'intensity', 0, 1.0),
        _size = NumberParameter('inputSize', 'size', 1, 8.0),
        _rows = NumberParameter('inputRows', 'rows', 2, 8.0),
        _columns = NumberParameter('inputColumns', 'columns', 3, 8.0),
        super([1.0, 8.0, 8.0, 8.0]);

  LookupTableShaderConfiguration.size8x64()
      : _intensity = NumberParameter('inputIntensity', 'intensity', 0, 1.0),
        _size = NumberParameter('inputSize', 'size', 1, 8.0),
        _rows = NumberParameter('inputRows', 'rows', 2, 64.0),
        _columns = NumberParameter('inputColumns', 'columns', 3, 8.0),
        super([1.0, 8.0, 64.0, 8.0]);

  LookupTableShaderConfiguration.size16x1()
      : _intensity = NumberParameter('inputIntensity', 'intensity', 0, 1.0),
        _size = NumberParameter('inputSize', 'size', 1, 16.0),
        _rows = NumberParameter('inputRows', 'rows', 2, 1.0),
        _columns = NumberParameter('inputColumns', 'columns', 3, 16.0),
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
  List<ShaderParameter> get parameters => [_intensity, _size, _rows, _columns];
}
