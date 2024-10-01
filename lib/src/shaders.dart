part of '../flutter_image_filters.dart';

String _shadersRoot =
    !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST')
        ? ''
        : 'packages/flutter_image_filters/';

Map<Type, Future<FragmentProgram> Function()> _fragmentPrograms = {
  MonochromeShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/monochrome.frag'),
  SquareLookupTableShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/lookup.frag'),
  HALDLookupTableShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/hald_lookup.frag'),
  BrightnessShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/brightness.frag'),
  ZoomBlurShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/zoom_blur.frag'),
  WhiteBalanceShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/white_balance.frag'),
  VignetteShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/vignette.frag'),
  VibranceShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/vibrance.frag'),
  ContrastShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/contrast.frag'),
  HueShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/hue.frag'),
  SwirlShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/swirl.frag'),
  SolarizeShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/solarize.frag'),
  SaturationShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/saturation.frag'),
  RGBShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/rgb.frag'),
  PosterizeShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/posterize.frag'),
  PixelationShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/pixelation.frag'),
  OpacityShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/opacity.frag'),
  LuminanceShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/luminance.frag'),
  LuminanceThresholdShaderConfiguration: () => FragmentProgram.fromAsset(
        '${_shadersRoot}shaders/luminance_threshold.frag',
      ),
/*  KuwaharaShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/kuwahara.frag'),*/
  HighlightShadowShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/highlight_shadow.frag'),
  BulgeDistortionShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/bulge_distortion.frag'),
  CGAColorspaceShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/cga_colorspace.frag'),
  ColorInvertShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/color_invert.frag'),
  ColorMatrixShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/color_matrix.frag'),
  CrosshatchShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/crosshatch.frag'),
  ExposureShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/exposure.frag'),
  FalseColorShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/false_color.frag'),
  GammaShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/gamma.frag'),
  GrayscaleShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/grayscale.frag'),
  GlassSphereShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/glass_sphere.frag'),
  HalftoneShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/halftone.frag'),
  HazeShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/haze.frag'),
  NoneShaderConfiguration: () =>
      FragmentProgram.fromAsset('${_shadersRoot}shaders/none.frag'),
};
