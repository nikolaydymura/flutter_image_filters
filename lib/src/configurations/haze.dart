part of flutter_image_filters;

class HazeShaderConfiguration extends ShaderConfiguration {
  HazeShaderConfiguration()
      : _distance = ShaderNumberParameter(
          'inputDistance',
          'distance',
          0.2,
          0,
        ),
        _slope = ShaderNumberParameter('inputSlope', 'slope', 0.0, 1),
        super([0.2, 0.0]);

  final NumberParameter _distance;
  final NumberParameter _slope;

  set distance(double value) {
    _distance.value = value;
    _distance.update(this);
  }

  set slope(double value) {
    _slope.value = value;
    _slope.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_distance, _slope];
}
