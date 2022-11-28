import 'dart:io';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = PixelationShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('PixelationShaderConfiguration', () {
    test('pixelation default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'pixelation_default.jpeg',
      );
    });
    test('pixelation 0.001, 0.001, 0.1', () async {
      configuration.widthFactor = 0.001;
      configuration.heightFactor = 0.001;
      configuration.pixel = 0.01;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'pixelation_0.001_0.001_0.1.jpeg',
      );
    });
    test('pixelation 0.002, 0.002, 0.2', () async {
      configuration.widthFactor = 0.002;
      configuration.heightFactor = 0.002;
      configuration.pixel = 0.02;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'pixelation_0.002_0.002_0.2.jpeg',
      );
    });
    test('pixelation 0.009, 0.009, 0.9', () async {
      configuration.widthFactor = 0.009;
      configuration.heightFactor = 0.009;
      configuration.pixel = 0.09;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'pixelation_0.009_0.009_0.9.jpeg',
      );
    });
  });
}
