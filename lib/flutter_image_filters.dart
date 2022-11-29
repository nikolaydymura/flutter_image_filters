library flutter_image_filters;

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

import 'src/shaders/brightness_sprv.dart';
import 'src/shaders/bulge_distortion_sprv.dart';
import 'src/shaders/cga_colorspace_sprv.dart';
import 'src/shaders/color_invert_sprv.dart';
import 'src/shaders/color_matrix_sprv.dart';
import 'src/shaders/contrast_sprv.dart';
import 'src/shaders/crosshatch_sprv.dart';
import 'src/shaders/exposure_sprv.dart';
import 'src/shaders/false_color_sprv.dart';
import 'src/shaders/gamma_sprv.dart';
import 'src/shaders/glass_sphere_sprv.dart';
import 'src/shaders/grayscale_sprv.dart';
import 'src/shaders/halftone_sprv.dart';
import 'src/shaders/highlight_shadow_sprv.dart';
import 'src/shaders/hue_sprv.dart';
import 'src/shaders/kuwahara_sprv.dart';
import 'src/shaders/lookup_sprv.dart';
import 'src/shaders/luminance_sprv.dart';
import 'src/shaders/luminance_threshold_sprv.dart';
import 'src/shaders/monochrome_sprv.dart';
import 'src/shaders/none_sprv.dart';
import 'src/shaders/opacity_sprv.dart';
import 'src/shaders/pixelation_sprv.dart';
import 'src/shaders/posterize_sprv.dart';
import 'src/shaders/rgb_sprv.dart';
import 'src/shaders/saturation_sprv.dart';
import 'src/shaders/solarize_sprv.dart';
import 'src/shaders/swirl_sprv.dart';
import 'src/shaders/vibrance_sprv.dart';
import 'src/shaders/vignette_sprv.dart';
import 'src/shaders/white_balance_sprv.dart';
import 'src/shaders/zoom_blur_sprv.dart';

part 'src/configurations/brightness.dart';
part 'src/configurations/bulge_distortion.dart';
part 'src/configurations/cga_colorspace.dart';
part 'src/configurations/color_invert.dart';
part 'src/configurations/color_matrix.dart';
part 'src/configurations/configuration.dart';
part 'src/configurations/contrast.dart';
part 'src/configurations/crosshatch.dart';
part 'src/configurations/exposure.dart';
part 'src/configurations/false_color.dart';
part 'src/configurations/gamma.dart';
part 'src/configurations/glass_sphere.dart';
part 'src/configurations/grayscale.dart';
part 'src/configurations/halftone.dart';
part 'src/configurations/highlight_shadow.dart';
part 'src/configurations/hue.dart';
part 'src/configurations/kuwahara.dart';
part 'src/configurations/lookup.dart';
part 'src/configurations/luminance.dart';
part 'src/configurations/luminance_threshold.dart';
part 'src/configurations/monochrome.dart';
part 'src/configurations/none.dart';
part 'src/configurations/opacity.dart';
part 'src/configurations/pixelation.dart';
part 'src/configurations/posterize.dart';
part 'src/configurations/rgb.dart';
part 'src/configurations/saturation.dart';
part 'src/configurations/solarize.dart';
part 'src/configurations/swirl.dart';
part 'src/configurations/vibrance.dart';
part 'src/configurations/vignette.dart';
part 'src/configurations/white_balance.dart';
part 'src/configurations/zoom_blur.dart';
part 'src/shaders.dart';
part 'src/texture_source.dart';
part 'src/widgets/image_shader_painter.dart';
part 'src/widgets/image_shader_preview.dart';
part 'src/parameters.dart';

class FlutterImageFilters {
// coverage:ignore-start
  FlutterImageFilters._();
// coverage:ignore-end

  static Iterable<String> get availableFilters =>
      kIsWeb ? const <String>[] : _availableFilters.keys;

  static final Map<String, ShaderConfiguration Function()> _availableFilters = {
    'Brightness': () => BrightnessShaderConfiguration(),
    'Bulge Distortion': () => BulgeDistortionShaderConfiguration(),
    'CGA Colorspace': () => CGAColorspaceShaderConfiguration(),
    'Color Invert': () => ColorInvertShaderConfiguration(),
    'Color Matrix': () => ColorMatrixShaderConfiguration(),
    'Contrast': () => ContrastShaderConfiguration(),
    'Crosshatch': () => CrosshatchShaderConfiguration(),
    'Exposure': () => ExposureShaderConfiguration(),
    'False Color': () => FalseColorShaderConfiguration(),
    'Gamma': () => GammaShaderConfiguration(),
    //TODO: 'Glass Sphere': () => GlassSphereShaderConfiguration(),
    'Grayscale': () => GrayscaleShaderConfiguration(),
    'Halftone': () => HalftoneShaderConfiguration(),
    'Highlight Shadow': () => HighlightShadowShaderConfiguration(),
    'Hue': () => HueShaderConfiguration(),
    //TODO: 'Kuwahara': () => KuwaharaShaderConfiguration(),
    'Lookup Table': () => LookupTableShaderConfiguration(),
    'Luminance Threshold': () => LuminanceThresholdShaderConfiguration(),
    'Luminance': () => LuminanceShaderConfiguration(),
    'Monochrome': () => MonochromeShaderConfiguration(),
    'Opacity': () => OpacityShaderConfiguration(),
    'Pixelation': () => PixelationShaderConfiguration(),
    'Posterize': () => PosterizeShaderConfiguration(),
    'RGB': () => RGBShaderConfiguration(),
    'Saturation': () => SaturationShaderConfiguration(),
    'Solarize': () => SolarizeShaderConfiguration(),
    'Swirl': () => SwirlShaderConfiguration(),
    'Vibrance': () => VibranceShaderConfiguration(),
    'Vignette': () => VignetteShaderConfiguration(),
    'White Balance': () => WhiteBalanceShaderConfiguration(),
    'Zoom Blur': () => ZoomBlurShaderConfiguration(),
  };

  static ShaderConfiguration? createFilter({required String displayName}) {
    if (kIsWeb) {
      return null;
    }
    return _availableFilters[displayName]?.call();
  }
}
