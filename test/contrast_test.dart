import 'dart:io';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = ContrastShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('ContrastShaderConfiguration', () {
    test('contrast default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'contrast_default.jpeg',
      );
    });
    test('contrast 0.5', () async {
      configuration.contrast = 0.5;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'contrast_0.5.jpeg',
      );
    });
    test('contrast 2.5', () async {
      configuration.contrast = 2.5;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'contrast_2.5.jpeg',
      );
    });
    test('contrast 3.9', () async {
      configuration.contrast = 3.9;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'contrast_3.9.jpeg',
      );
    });
  });
}
