import 'dart:io';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = SaturationShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('SaturationShaderConfiguration', () {
    test('saturation default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'saturation_default.jpeg',
      );
    });
    test('saturation 0.5', () async {
      configuration.saturation = 0.5;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'saturation_0.5.jpeg',
      );
    });
    test('saturation 1.2', () async {
      configuration.saturation = 1.2;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'saturation_1.2.jpeg',
      );
    });
    test('saturation 1.9', () async {
      configuration.saturation = 1.9;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'saturation_1.9.jpeg',
      );
    });
  });
}
