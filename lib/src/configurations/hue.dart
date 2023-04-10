part of flutter_image_filters;

class HueShaderConfiguration extends ShaderConfiguration {
  HueShaderConfiguration()
      : _hueAdjust = ShaderRangeNumberParameter(
          'inputHueAdjust',
          'hueAdjust',
          90.0,
          0,
          min: 0.0,
          max: 360.0,
        ),
        super([90.0]);

  final NumberParameter _hueAdjust;

  set hueAdjust(double value) {
    _hueAdjust.value = value;
    _hueAdjust.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_hueAdjust];
}
