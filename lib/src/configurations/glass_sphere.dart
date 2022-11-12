part of image_filters;

class GlassSphereShaderConfiguration extends ShaderConfiguration {
  final PointParameter _center;
  final NumberParameter _radius;
  final NumberParameter _aspectRatio;
  final NumberParameter _refractiveIndex;

  GlassSphereShaderConfiguration()
      : _center = PointParameter(
          'inputCenter',
          'center',
          0,
          const Point<double>(0.5, 0.5),
        ),
        _radius = NumberParameter('inputRadius', 'radius', 2, 0.25),
        _aspectRatio =
            NumberParameter('inputAspectRatio', 'aspectRatio', 3, 0.67),
        _refractiveIndex =
            NumberParameter('inputRefractiveIndex', 'refractiveIndex', 4, 0.71),
        super([0.5, 0.5, 0.25, 0.67, 0.71]);

  set center(Point<double> value) {
    _center.value = value;
    _center.update(this);
  }

  set radius(double value) {
    _radius.value = value;
    _radius.update(this);
  }

  set aspectRatio(double value) {
    _aspectRatio.value = value;
    _aspectRatio.update(this);
  }

  set refractiveIndex(double value) {
    _refractiveIndex.value = value;
    _refractiveIndex.update(this);
  }

  @override
  List<ShaderParameter> get parameters =>
      [_center, _radius, _aspectRatio, _refractiveIndex];
}
