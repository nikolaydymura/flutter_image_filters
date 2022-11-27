import 'dart:io';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = LuminanceThresholdShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('LuminanceThresholdShaderConfiguration', () {
    test('luminance threshold default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'luminance_threshold_default.jpeg',
      );
    });
    test('luminance threshold 0.1', () async {
      configuration.threshold = 0.1;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'luminance_threshold_0.1.jpeg',
      );
    });
    test('luminance threshold 0.3', () async {
      configuration.threshold = 0.3;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'luminance_threshold_0.3.jpeg',
      );
    });
    test('luminance threshold 0.4', () async {
      configuration.threshold = 0.4;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'luminance_threshold_0.4.jpeg',
      );
    });
  });
}
