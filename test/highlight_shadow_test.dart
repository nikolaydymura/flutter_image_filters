import 'dart:io';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = HighlightShadowShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('HighlightShadowShaderConfiguration', () {
    test('highlight shadow default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'highlight_shadow_default.jpeg',
      );
    });
    test('highlight shadow 0.1, 0.1', () async {
      configuration.shadows = 0.1;
      configuration.highlights = 0.1;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'highlight_shadow_0.1_0.1.jpeg',
      );
    });
    test('highlight shadow 0.5, 0.5', () async {
      configuration.shadows = 0.5;
      configuration.highlights = 0.5;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'highlight_shadow_0.5_0.5.jpeg',
      );
    });
    test('highlight shadow 0.9, 0.9', () async {
      configuration.shadows = 0.5;
      configuration.highlights = 0.5;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'highlight_shadow_0.9_0.9.jpeg',
      );
    });
  });
}
