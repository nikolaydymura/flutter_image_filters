part of image_filters;

class HueShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _hueAdjust;

  HueShaderConfiguration()
      : _hueAdjust = NumberParameter(
          'inputHueAdjust',
          'hueAdjust',
          0,
          90.0,
        ),
        super([90.0]);

  set hueAdjust(double value) {
    _hueAdjust.value = value;
    _hueAdjust.update(this);
  }

  @override
  List<ShaderParameter> get parameters => [_hueAdjust];
}
