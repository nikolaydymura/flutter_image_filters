part of image_filters;

Map<Type, Future<FragmentProgram> Function()> _shaders = {
  MonochromeShaderConfiguration: () => monochromeFragmentProgram(),
  LookupTableShaderConfiguration: () => lookupFragmentProgram(),
  BrightnessShaderConfiguration: () => brightnessFragmentProgram(),
  ZoomBlurShaderConfiguration: () => zoomBlurFragmentProgram(),
  WhiteBalanceShaderConfiguration: () => whiteBalanceFragmentProgram(),
  VignetteShaderConfiguration: () => vignetteFragmentProgram(),
  VibranceShaderConfiguration: () => vibranceFragmentProgram(),
  ContrastShaderConfiguration: () => contrastFragmentProgram(),
  HueShaderConfiguration: () => hueFragmentProgram(),
};

Map<String, ShaderConfiguration Function()> availableShaders = {
  'Monochrome': () => MonochromeShaderConfiguration(),
  'Lookup Table': () => LookupTableShaderConfiguration(),
  'Brightness': () => BrightnessShaderConfiguration(),
  'Zoom Blur': () => ZoomBlurShaderConfiguration(),
  'White Balance': () => WhiteBalanceShaderConfiguration(),
  'Vignette': () => VignetteShaderConfiguration(),
  'Vibrance': () => VibranceShaderConfiguration(),
  'Contrast': () => ContrastShaderConfiguration(),
  'Hue': () => HueShaderConfiguration(),
};
