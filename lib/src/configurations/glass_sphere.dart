part of image_filters;

class GlassSphereShaderConfiguration extends ShaderConfiguration {
  final PointParameter _center;
  final NumberParameter _radius;
  final AspectRatioParameter _aspectRatio;
  final NumberParameter _refractiveIndex;

  GlassSphereShaderConfiguration()
      : _center = ShaderPointParameter(
          'inputCenter',
          'center',
          const Point<double>(0.5, 0.5),
          0,
        ),
        _radius = ShaderNumberParameter(
          'inputRadius',
          'radius',
          0.25,
          2,
        ),
        _aspectRatio = ShaderAspectRatioParameter(
          'inputAspectRatio',
          'aspectRatio',
          const Size(1, 1),
          3,
        ),
        _refractiveIndex = ShaderNumberParameter(
          'inputRefractiveIndex',
          'refractiveIndex',
          0.71,
          4,
        ),
        super([0.5, 0.5, 0.25, 1.0, 0.71]);

  set center(Point<double> value) {
    _center.value = value;
    _center.update(this);
  }

  set radius(double value) {
    _radius.value = value;
    _radius.update(this);
  }

  set refractiveIndex(double value) {
    _refractiveIndex.value = value;
    _refractiveIndex.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters =>
      [_center, _radius, _aspectRatio, _refractiveIndex];
}
