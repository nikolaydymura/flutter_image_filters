import 'dart:io';
import 'dart:math';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = BulgeDistortionShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('BulgeDistortionShaderConfiguration', () {
    test('bulge_distortion default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'bulge_distortion_default.jpeg',
      );
    });
    test('bulge_distortion 0.1, 0.1, 0.1, -0,5', () async {
      configuration.center = const Point<double>(0.1, 0.1);
      configuration.radius = 0.1;
      configuration.scale = -0.5;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'bulge_distortion_0.1_0.1_0.1_minus_0.5.jpeg',
      );
    });
    test('bulge_distortion 0.1', () async {
      configuration.center = const Point<double>(0.1, 0.1);
      configuration.radius = 0.1;
      configuration.scale = 0.1;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'bulge_distortion_0.1.jpeg',
      );
    });
    test('bulge_distortion 0.2', () async {
      configuration.center = const Point<double>(0.2, 0.2);
      configuration.radius = 0.2;
      configuration.scale = 0.2;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'bulge_distortion_0.2.jpeg',
      );
    });
    test('bulge_distortion 0.9', () async {
      configuration.center = const Point<double>(0.9, 0.9);
      configuration.radius = 0.9;
      configuration.scale = 0.9;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'bulge_distortion_0.9.jpeg',
      );
    });
  });
}
