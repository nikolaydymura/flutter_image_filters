part of image_filters;

Map<Type, Future<FragmentProgram> Function()> _shaders = {
  MonochromeShaderConfiguration: () => monochromeFragmentProgram()
};
