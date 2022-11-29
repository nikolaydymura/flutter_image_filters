import 'dart:io';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = ExposureShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('ExposureShaderConfiguration', () {
    test('exposure default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'exposure_default.jpeg',
      );
    });
    test('exposure -9.0', () async {
      configuration.exposure = -9.0;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'exposure_minus_9.0.jpeg',
      );
    });
    test('exposure -1.0', () async {
      configuration.exposure = -1.5;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'exposure_minus_1.0.jpeg',
      );
    });
    test('exposure 5.9', () async {
      configuration.exposure = 5.9;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'exposure_5.9.jpeg',
      );
    });
    test('exposure 9.0', () async {
      configuration.exposure = 59.0;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'exposure_9.0.jpeg',
      );
    });
  });
}
