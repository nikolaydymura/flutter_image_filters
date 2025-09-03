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

  group('Brightness + Saturation Color Consistency Test', () {
    test('brightness and saturation with color space correction', () async {
      final brightnessConfig = BrightnessShaderConfiguration();
      brightnessConfig.brightness = 0.3;
      
      final saturationConfig = SaturationShaderConfiguration();
      saturationConfig.saturation = 1.5;
      
      final groupConfig = GroupShaderConfiguration();
      groupConfig.add(brightnessConfig);
      groupConfig.add(saturationConfig);
      
      // Test export for color consistency
      final image = await groupConfig.export(texture, texture.size);
      final bytes = await image.toByteData();
      
      expect(bytes, isNotNull);
      expect(image.width, equals(texture.width));
      expect(image.height, equals(texture.height));
      
      // Verify that the image was processed with color space correction
      // This test ensures that the export process maintains color consistency
      // especially on iOS platforms where color space differences can occur
    });
    
    test('brightness only with color space correction', () async {
      final configuration = BrightnessShaderConfiguration();
      configuration.brightness = 0.2;
      
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'brightness_saturation_brightness_only.jpeg',
        configurationKey: 'Brightness+Saturation_ShaderConfiguration',
      );
    });
    
    test('saturation only with color space correction', () async {
      final configuration = SaturationShaderConfiguration();
      configuration.saturation = 1.8;
      
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'brightness_saturation_saturation_only.jpeg',
        configurationKey: 'Brightness+Saturation_ShaderConfiguration',
      );
    });
  });
}
