import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = FalseColorShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('FalseColorShaderConfiguration', () {
    test('false_color default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'false_color_default.jpeg',
      );
    });
    test('false_color 0.0.100, 250.0.0', () async {
      configuration.firstColor = const Color.fromRGBO(0, 0, 100, 1.0);
      configuration.secondColor = const Color.fromRGBO(250, 0, 0, 1.0);

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'false_color_0.0.100_250.0.0.jpeg',
      );
    });

    test('false_color 0.0.50, 150.0.0', () async {
      configuration.firstColor = const Color.fromRGBO(0, 0, 50, 1.0);
      configuration.secondColor = const Color.fromRGBO(150, 0, 0, 1.0);

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'false_color_0.0.50_150.0.0.jpeg',
      );
    });
    test('false_color 0.0.0, 75.0.0', () async {
      configuration.firstColor = const Color.fromRGBO(0, 0, 0, 1.0);
      configuration.secondColor = const Color.fromRGBO(75, 0, 0, 1.0);

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'false_color_0.0.0_75.0.0.jpeg',
      );
    });
  });
}
