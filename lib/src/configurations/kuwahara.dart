part of '../../flutter_image_filters.dart';

/// Describes kuwahara manipulations
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

  /// Updates the [radius] value.
  set radius(double value) {
    _radius.value = value;
    _radius.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_radius];
}
