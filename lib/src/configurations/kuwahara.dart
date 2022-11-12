part of image_filters;

class KuwaharaShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _radius;

  KuwaharaShaderConfiguration()
      : _radius = _IntParameter(
          'inputRadius',
          'radius',
          0,
          3.0,
        ),
        super([3.0]);

  set radius(double value) {
    _radius.value = value;
    _radius.update(this);
  }

  @override
  List<ShaderParameter> get parameters => [_radius];
}

class _IntParameter extends NumberParameter {
  _IntParameter(super.shaderName, super.displayName, super.offset, super.value);

  @override
  void update(ShaderConfiguration configuration) {
    configuration._floats[_offset] = value.toInt().toDouble();
  }
}
