import 'dart:io';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = HalftoneShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('HalftoneShaderConfiguration', () {
    test('zoom_blur default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'halftone_default.jpeg',
      );
    });
    test('halftone 0.02', () async {
      configuration.fractionalWidthOfPixel = 0.02;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'halftone_0.02.jpeg',
      );
    });
    test('halftone 0.05', () async {
      configuration.fractionalWidthOfPixel = 0.05;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'halftone_0.05.jpeg',
      );
    });
    test('halftone 0.09', () async {
      configuration.fractionalWidthOfPixel = 0.09;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'halftone_0.09.jpeg',
      );
    });
  });
}
