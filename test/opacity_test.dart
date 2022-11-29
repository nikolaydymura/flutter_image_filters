import 'dart:io';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = OpacityShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('OpacityShaderConfiguration', () {
    test('opacity default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'opacity_default.jpeg',
      );
    });
    test('opacity 0.1', () async {
      configuration.opacity = 0.1;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'opacity_0.1.jpeg',
      );
    });
    test('opacity 0.5', () async {
      configuration.opacity = 0.5;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'opacity_0.5.jpeg',
      );
    });
    test('opacity 0.9', () async {
      configuration.opacity = 0.9;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'opacity_0.9.jpeg',
      );
    });
  });
}
