import 'dart:io';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = RGBShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('RGBShaderConfiguration', () {
    test('rgb default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'rgb_default.jpeg',
      );
    });
    test('rgb 255, 0, 0', () async {
      configuration.red = 255;
      configuration.green = 0;
      configuration.blue = 0;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'rgb_255_0_0.jpeg',
      );
    });
    test('rgb 0, 255, 0', () async {
      configuration.red = 0;
      configuration.green = 255;
      configuration.blue = 0;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'rgb_0_255_0.jpeg',
      );
    });
    test('rgb 0, 0, 255', () async {
      configuration.red = 0;
      configuration.green = 0;
      configuration.blue = 255;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'rgb_0_0_255.jpeg',
      );
    });
  });
}
