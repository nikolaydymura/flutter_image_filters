import 'dart:io';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = MonochromeShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('MonochromeShaderConfiguration', () {
    test('monochrome default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'monochrome_default.jpeg',
      );
    });
    test('monochrome 0.1', () async {
      configuration.intensity = 0.1;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'monochrome_0.1.jpeg',
      );
    });
    test('monochrome 0.5', () async {
      configuration.intensity = 0.5;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'monochrome_0.5.jpeg',
      );
    });
    test('monochrome 0.9', () async {
      configuration.intensity = 0.9;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'monochrome_0.9.jpeg',
      );
    });
  });
}
