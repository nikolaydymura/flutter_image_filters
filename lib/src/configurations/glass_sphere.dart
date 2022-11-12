part of image_filters;

class GlassSphereShaderConfiguration extends ShaderConfiguration {
  final PointParameter _center;
  final NumberParameter _radius;
  final AspectRatioParameter _aspectRatio;
  final NumberParameter _refractiveIndex;

  GlassSphereShaderConfiguration()
      : _center = PointParameter(
          'inputCenter',
          'center',
          0,
          const Point<double>(0.5, 0.5),
        ),
        _radius = NumberParameter('inputRadius', 'radius', 2, 0.25),
        _aspectRatio = AspectRatioParameter(
          'inputAspectRatio',
          'aspectRatio',
          3,
          const Size(1, 1),
        ),
        _refractiveIndex =
            NumberParameter('inputRefractiveIndex', 'refractiveIndex', 4, 0.71),
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
  List<ShaderParameter> get parameters =>
      [_center, _radius, _aspectRatio, _refractiveIndex];
}
