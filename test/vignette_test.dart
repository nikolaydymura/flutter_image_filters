import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  late VignetteShaderConfiguration configuration;

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });
  setUp(() {
    configuration = VignetteShaderConfiguration();
  });

  group('VignetteShaderConfiguration', () {
    test('vignette default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'vignette_default.jpeg',
      );
    });
    test('vignette red', () async {
      configuration.color = Colors.red;
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'vignette_red.jpeg',
      );
    });
    test('vignette 0.1, 0.1, 0.1, 0.55', () async {
      configuration.center = const Point<double>(0.1, 0.1);
      configuration.start = 0.1;
      configuration.end = 0.55;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'vignette_0.1_0.01_0.01_0.55.jpeg',
      );
    });
    test('vignette 0.2, 0.2, 0.2, 0.65', () async {
      configuration.center = const Point<double>(0.2, 0.2);
      configuration.start = 0.2;
      configuration.end = 0.65;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'vignette_0.2_0.2_0.2_0.65.jpeg',
      );
    });
    test('vignette 0.9, 0.9, 0.4, 0.85', () async {
      configuration.center = const Point<double>(0.9, 0.9);
      configuration.start = 0.4;
      configuration.end = 0.5;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'vignette_0.9_0.09_0.4_0.85.jpeg',
      );
    });
  });
}
