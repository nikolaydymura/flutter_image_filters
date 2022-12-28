import 'dart:io';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });
  group('(Brightness+Saturation) ShaderConfiguration', () {
    test('default', () async {
      final configuration1 = BrightnessShaderConfiguration();
      final configuration2 = SaturationShaderConfiguration();
      final configuration = GroupShaderConfiguration();
      configuration.add(configuration1);
      configuration.add(configuration2);
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'default.jpeg',
        configurationKey: 'Brightness+Saturation_ShaderConfiguration',
      );
    });
    test('75%', () async {
      final configuration1 = BrightnessShaderConfiguration();
      final configuration2 = SaturationShaderConfiguration();
      final configuration = GroupShaderConfiguration();
      configuration1.brightness = 0.0;
      configuration2.saturation = 0.5;
      configuration.add(configuration1);
      configuration.add(configuration2);
      await expectFilteredSuccessfully(
        configuration,
        texture,
        '75.jpeg',
        configurationKey: 'Brightness+Saturation_ShaderConfiguration',
      );
    });
  });
}
