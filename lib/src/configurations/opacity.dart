part of image_filters;

class OpacityShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _opacity;

  OpacityShaderConfiguration()
      : _opacity = SliderNumberParameter(
          'inputOpacity',
          'opacity',
          0,
          1.0,
          min: .0,
          max: 1.0,
        ),
        super([1.0]);

  set opacity(double value) {
    _opacity.value = value;
    _opacity.update(this);
  }

  @override
  List<ShaderParameter> get parameters => [_opacity];
}
