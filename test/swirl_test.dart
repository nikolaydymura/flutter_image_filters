import 'dart:io';
import 'dart:math';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = SwirlShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('SwirlShaderConfiguration', () {
    test('opacity default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'swirl_default.jpeg',
      );
    });
    test('swirl 0.1', () async {
      configuration.center = const Point<double>(0.1, 0.1);
      configuration.radius = 0.1;
      configuration.angle = 0.1;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'swirl_0.1.jpeg',
      );
    });
    test('swirl 0.2', () async {
      configuration.center = const Point<double>(0.2, 0.2);
      configuration.radius = 0.2;
      configuration.angle = 0.2;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'swirl_0.2.jpeg',
      );
    });
    test('swirl 0.9', () async {
      configuration.center = const Point<double>(0.9, 0.9);
      configuration.radius = 0.9;
      configuration.angle = 0.9;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'swirl_0.9.jpeg',
      );
    });
  });
}
