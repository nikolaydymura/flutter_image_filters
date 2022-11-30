import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = ColorMatrixShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('ColorMatrixShaderConfiguration', () {
    test('color_matrix default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'color_matrix_default.jpeg',
      );
    });
    test('color_matrix 0.1', () async {
      configuration.intensity = 0.1;
      configuration.colorMatrix = Matrix4.identity();

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'color_matrix_0.1.jpeg',
      );
    });
    test('color_matrix 0.5', () async {
      configuration.intensity = 0.5;
      configuration.colorMatrix = Matrix4.identity();

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'color_matrix_0.5.jpeg',
      );
    });
    test('color_matrix 0.9', () async {
      configuration.intensity = 0.9;
      configuration.colorMatrix = Matrix4.identity();

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'color_matrix_0.9.jpeg',
      );
    });
  });
}
