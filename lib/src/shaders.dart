part of image_filters;

Map<Type, Future<FragmentProgram> Function()> _shaders = {
  MonochromeShaderConfiguration: () => monochromeFragmentProgram(),
  LookupTableShaderConfiguration: () => lookupFragmentProgram(),
};

Map<String, ShaderConfiguration Function()> availableShaders = {
  'Monochrome': () => MonochromeShaderConfiguration(),
  'Lookup Table': () => LookupTableShaderConfiguration(),
};
