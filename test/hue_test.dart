import 'dart:io';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = HueShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('HueShaderConfiguration', () {
    test('hue default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'hue_default.jpeg',
      );
    });
    test('hue 1.0', () async {
      configuration.hueAdjust = 1.0;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'hue_1.0.jpeg',
      );
    });
    test('hue 45.5', () async {
      configuration.hueAdjust = 45.5;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'hue_45.5.jpeg',
      );
    });
    test('hue 70.0', () async {
      configuration.hueAdjust = 70.0;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'hue_70.0.jpeg',
      );
    });
  });
}
