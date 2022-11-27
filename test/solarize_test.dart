import 'dart:io';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = SolarizeShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('SolarizeShaderConfiguration', () {
    test('solarize default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'solarize_default.jpeg',
      );
    });
    test('solarize 1.0', () async {
      configuration.threshold = 1.0;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'solarize_1.0.jpeg',
      );
    });
    test('solarize 0.1', () async {
      configuration.threshold = 0.1;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'solarize_0.1.jpeg',
      );
    });
    test('solarize 0.25', () async {
      configuration.threshold = 0.25;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'solarize_0.25.jpeg',
      );
    });
  });
}
