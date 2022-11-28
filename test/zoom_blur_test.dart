import 'dart:io';
import 'dart:math';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = ZoomBlurShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('ZoomBlurShaderConfiguration', () {
    test('zoom_blur default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'zoom_blur_default.jpeg',
      );
    });
    test('zoom_blur 0.1', () async {
      configuration.size = 0.1;
      configuration.center = const Point<double>(0.1, 0.1);

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'zoom_blur_0.1.jpeg',
      );
    });
    test('zoom_blur 0.2', () async {
      configuration.size = 0.2;
      configuration.center = const Point<double>(0.2, 0.2);

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'zoom_blur_0.2.jpeg',
      );
    });
    test('zoom_blur 0.9', () async {
      configuration.size = 0.9;
      configuration.center = const Point<double>(0.9, 0.9);

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'zoom_blur_0.9.jpeg',
      );
    });
  });
}
