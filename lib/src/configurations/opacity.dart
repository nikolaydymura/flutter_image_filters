part of flutter_image_filters;

class OpacityShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _opacity;

  OpacityShaderConfiguration()
      : _opacity = ShaderRangeNumberParameter(
          'inputOpacity',
          'opacity',
          1.0,
          0,
          min: .0,
          max: 1.0,
        ),
        super([1.0]);

  set opacity(double value) {
    _opacity.value = value;
    _opacity.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_opacity];
}
