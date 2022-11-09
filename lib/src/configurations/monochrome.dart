part of image_filters;

class MonochromeShaderConfiguration extends ShaderConfiguration {
  final List<double> _floats;

  MonochromeShaderConfiguration() : _floats = [1.0, 0.6, 0.45, 0.3];

  void setIntensity(double value) {
    _floats[0] = value;
  }

  void setColor(Color value) {
    _floats[1] = value.red / 255.0;
    _floats[2] = value.green / 255.0;
    _floats[3] = value.blue / 255.0;
  }

  @override
  Iterable<double> get numUniforms => _floats;
}
