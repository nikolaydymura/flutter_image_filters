part of image_filters;

class KuwaharaShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _radius;

  KuwaharaShaderConfiguration()
      : _radius = ShaderIntParameter(
          'inputRadius',
          'radius',
          3.0,
          0,
        ),
        super([3.0]);

  set radius(double value) {
    _radius.value = value;
    _radius.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_radius];
}
