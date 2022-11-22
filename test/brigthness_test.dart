import 'dart:io';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });
  group('BrightnessShaderConfiguration', () {
    test('brightness default', () async {
      final configuration = BrightnessShaderConfiguration();
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'brightness_default.jpeg',
      );
    });
    test('brightness 0.1', () async {
      final configuration = BrightnessShaderConfiguration();
      configuration.brightness = 0.1;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'brightness_0.1.jpeg',
      );
    });
    test('brightness 0.5', () async {
      final configuration = BrightnessShaderConfiguration();
      configuration.brightness = 0.5;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'brightness_0.5.jpeg',
      );
    });
    test('brightness 0.9', () async {
      final configuration = BrightnessShaderConfiguration();
      configuration.brightness = 0.9;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'brightness_0.9.jpeg',
      );
    });
  });
}
