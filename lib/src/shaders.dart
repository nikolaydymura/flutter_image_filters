part of image_filters;

Map<Type, Future<FragmentProgram> Function()> _shaders = {
  MonochromeShaderConfiguration: () => monochromeFragmentProgram(),
  LookupTableShaderConfiguration: () => lookupFragmentProgram(),
  BrightnessShaderConfiguration: () => brightnessFragmentProgram(),
};

Map<String, ShaderConfiguration Function()> availableShaders = {
  'Monochrome': () => MonochromeShaderConfiguration(),
  'Lookup Table': () => LookupTableShaderConfiguration(),
  'Brightness': () => BrightnessShaderConfiguration(),
};
