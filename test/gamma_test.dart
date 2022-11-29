import 'dart:io';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = GammaShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('GammaShaderConfiguration', () {
    test('gamma default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'gamma_default.jpeg',
      );
    });
    test('gamma 0.5', () async {
      configuration.gamma = 0.5;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'gamma_0.5.jpeg',
      );
    });
    test('gamma 1.5', () async {
      configuration.gamma = 1.5;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'gamma_1.5.jpeg',
      );
    });
    test('gamma 2.9', () async {
      configuration.gamma = 2.9;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'gamma_2.9.jpeg',
      );
    });
  });
}
