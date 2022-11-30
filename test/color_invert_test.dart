import 'dart:io';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = ColorInvertShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });
  group('ColorInvertShaderConfiguration', () {
    test('color_invert default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'color_invert_default.jpeg',
      );
    });
  });
}
