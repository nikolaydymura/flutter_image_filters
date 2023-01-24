import 'dart:io';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = HazeShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('HazeShaderConfiguration', () {
    test('haze default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'haze_default.jpeg',
      );
    });
    test('distance 0.5', () async {
      configuration.distance = 0.5;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'haze_distance_0.5.jpeg',
      );
    });
    test('slope 1.5', () async {
      configuration.slope = 1.5;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'haze_slope_1.5.jpeg',
      );
    });
  });
}
