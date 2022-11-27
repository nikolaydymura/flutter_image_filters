import 'dart:io';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = CrosshatchShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('CrosshatchShaderConfiguration', () {
    test('crosshatch default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'crosshatch_default.jpeg',
      );
    });
    test('crosshatch 0.01, 0.001', () async {
      configuration.crossHatchSpacing = 0.01;
      configuration.lineWidth = 0.001;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'crosshatch_0.01_0.001.jpeg',
      );
    });
    test('crosshatch 0.05, 0.005', () async {
      configuration.crossHatchSpacing = 0.05;
      configuration.lineWidth = 0.005;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'crosshatch_0.05_0.005.jpeg',
      );
    });
    test('crosshatch 0.09, 0.009', () async {
      configuration.crossHatchSpacing = 0.09;
      configuration.lineWidth = 0.009;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'crosshatch_0.09_0.009.jpeg',
      );
    });
  });
}
