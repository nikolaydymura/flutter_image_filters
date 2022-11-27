import 'dart:io';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = VibranceShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('VibranceShaderConfiguration', () {
    test('vibrance default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'vibrance_default.jpeg',
      );
    });
    test('vibrance 1.0', () async {
      configuration.vibrance = 1.0;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'vibrance_1.0.jpeg',
      );
    });
    test('vibrance 5.0', () async {
      configuration.vibrance = 5.0;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'vibrance_5.0.jpeg',
      );
    });
    test('vibrance 10.0', () async {
      configuration.vibrance = 10.0;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'vibrance_10.0.jpeg',
      );
    });
  });
}
