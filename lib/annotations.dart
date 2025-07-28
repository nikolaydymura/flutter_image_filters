class BunchShaderConfigs {
  final List<BunchShaderConfig> configs;

  const BunchShaderConfigs({required this.configs});
}

class BunchShaderConfig {
  final List<Type> shaders;
  final String output;
  final String? name;

  const BunchShaderConfig({
    required this.shaders,
    this.output = 'shaders',
    this.name,
  });
}
