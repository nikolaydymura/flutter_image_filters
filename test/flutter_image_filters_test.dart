import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('enlist all', () async {
    final filters = [
      'Brightness',
      'Bulge Distortion',
      'CGA Colorspace',
      'Color Invert',
      'Color Matrix',
      'Contrast',
      'Crosshatch',
      'Exposure',
      'False Color',
      'Gamma',
      'Grayscale',
      'Halftone',
      'Haze',
      'Highlight Shadow',
      'Hue',
      'HALD Lookup Table',
      'Square Lookup Table',
      'Luminance Threshold',
      'Luminance',
      'Monochrome',
      'Opacity',
      'Pixelation',
      'Posterize',
      'RGB',
      'Saturation',
      'Solarize',
      'Swirl',
      'Vibrance',
      'Vignette',
      'White Balance',
      'Zoom Blur',
    ];
    for (final name in filters) {
      final configuration = FlutterImageFilters.createFilter(displayName: name);
      expect(configuration, isNotNull);
    }
  });
}
