library;

import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:exif/exif.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

export 'package:exif/exif.dart' show IfdTag;
export 'annotations.dart' show BunchShaderConfig, BunchShaderConfigs;

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
part 'src/configurations/haze.dart';
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
part 'src/parameters.dart';
part 'src/shaders.dart';
part 'src/texture_source.dart';
part 'src/widgets/image_shader_painter.dart';
part 'src/widgets/image_shader_preview.dart';
part 'src/widgets/pipeline_image_shader_preview.dart';

class FlutterImageFilters {
// coverage:ignore-start
  FlutterImageFilters._();

// coverage:ignore-end

  static Future<void> prepare() async {
    await ShaderTextureParameter._loadEmptyTexture();
  }

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
    'Glass Sphere': () => GlassSphereShaderConfiguration(),
    'Grayscale': () => GrayscaleShaderConfiguration(),
    'Halftone': () => HalftoneShaderConfiguration(),
    'Haze': () => HazeShaderConfiguration(),
    'Highlight Shadow': () => HighlightShadowShaderConfiguration(),
    'Hue': () => HueShaderConfiguration(),
    //TODO: 'Kuwahara': () => KuwaharaShaderConfiguration(),
    'Square Lookup Table': () => SquareLookupTableShaderConfiguration(),
    'HALD Lookup Table': () => HALDLookupTableShaderConfiguration(),
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
    return _availableFilters[displayName]?.call();
  }

  static void register<T extends ShaderConfiguration>(
    Future<FragmentProgram> Function() fragmentProgramProvider, {
    bool override = false,
  }) {
    if (override) {
      _fragmentPrograms[T] = fragmentProgramProvider;
    } else {
      _fragmentPrograms.putIfAbsent(
        T,
        () => fragmentProgramProvider,
      );
    }
  }
}

class CustomBrightnessConfiguration extends ShaderConfiguration {
  final NumberParameter _brightness;

  CustomBrightnessConfiguration()
      : _brightness = ShaderRangeNumberParameter(
          'inputBrightness', // uniform name
          'brightness', // display name
          0.0,
          0, // default value
          min: -1.0, // minimum value
          max: 1.0, // maximum value
        ),
        super([0.0]); // default values

  // custom setter (optional)
  set brightness(double value) {
    _brightness.value = value;
  }

  // enlist all parameters
  @override
  List<ConfigurationParameter> get parameters => [_brightness];
}
