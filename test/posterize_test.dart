import 'dart:io';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = PosterizeShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('PosterizeShaderConfiguration', () {
    test('posterize default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'posterize_default.jpeg',
      );
    });
    test('posterize 1.5', () async {
      configuration.colorLevels = 1.5;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'posterize_1.5.jpeg',
      );
    });
    test('posterize 5.0', () async {
      configuration.colorLevels = 5.0;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'posterize_5.0.jpeg',
      );
    });
    test('posterize 150.0', () async {
      configuration.colorLevels = 150.0;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'posterize_150.0.jpeg',
      );
    });
    test('posterize 250.0', () async {
      configuration.colorLevels = 250.0;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'posterize_250.0.jpeg',
      );
    });
  });
}
