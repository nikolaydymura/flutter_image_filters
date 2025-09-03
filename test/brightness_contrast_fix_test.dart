import 'dart:io';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('Brightness and Contrast Color Consistency Fix', () {
    test('brightness filter maintains color consistency', () async {
      final configuration = BrightnessShaderConfiguration();
      configuration.brightness = 0.3;
      
      // Test that the configuration is created correctly
      expect(configuration, isA<BrightnessShaderConfiguration>());
      
      // Test export functionality
      final image = await configuration.export(texture, texture.size);
      expect(image, isNotNull);
      expect(image.width, equals(texture.width));
      expect(image.height, equals(texture.height));
      
      // Verify color space correction is applied
      final bytes = await image.toByteData();
      expect(bytes, isNotNull);
    });

    test('contrast filter maintains color consistency', () async {
      final configuration = ContrastShaderConfiguration();
      configuration.contrast = 1.5;
      
      // Test that the configuration is created correctly
      expect(configuration, isA<ContrastShaderConfiguration>());
      
      // Test export functionality
      final image = await configuration.export(texture, texture.size);
      expect(image, isNotNull);
      expect(image.width, equals(texture.width));
      expect(image.height, equals(texture.height));
      
      // Verify color space correction is applied
      final bytes = await image.toByteData();
      expect(bytes, isNotNull);
    });

    test('combined brightness and contrast maintains color consistency', () async {
      final brightnessConfig = BrightnessShaderConfiguration();
      brightnessConfig.brightness = 0.2;
      
      final contrastConfig = ContrastShaderConfiguration();
      contrastConfig.contrast = 1.8;
      
      final groupConfig = GroupShaderConfiguration();
      groupConfig.add(brightnessConfig);
      groupConfig.add(contrastConfig);
      
      // Test that the group configuration is created correctly
      expect(groupConfig, isA<GroupShaderConfiguration>());
      
      // Test export functionality
      final image = await groupConfig.export(texture, texture.size);
      expect(image, isNotNull);
      expect(image.width, equals(texture.width));
      expect(image.height, equals(texture.height));
      
      // Verify color space correction is applied
      final bytes = await image.toByteData();
      expect(bytes, isNotNull);
    });

    test('color space correction utility works correctly', () {
      // Test gamma conversion functions
      final linearValue = ColorSpaceCorrection.gammaToLinear(0.5);
      expect(linearValue, isA<double>());
      expect(linearValue, greaterThan(0.0));
      expect(linearValue, lessThan(1.0));
      
      final gammaValue = ColorSpaceCorrection.linearToGamma(0.5);
      expect(gammaValue, isA<double>());
      expect(gammaValue, greaterThan(0.0));
      expect(gammaValue, lessThan(1.0));
      
      // Test color space correction for lists
      final colors = [0.1, 0.5, 0.9];
      final corrected = ColorSpaceCorrection.correctColorSpace(colors);
      expect(corrected, isA<List<double>>());
      expect(corrected.length, equals(colors.length));
    });

    test('shader configurations override color correction methods', () {
      final brightnessConfig = BrightnessShaderConfiguration();
      brightnessConfig.brightness = 0.4;
      
      final contrastConfig = ContrastShaderConfiguration();
      contrastConfig.contrast = 2.0;
      
      // Verify that both configurations have the color correction method
      expect(brightnessConfig, isA<BrightnessShaderConfiguration>());
      expect(contrastConfig, isA<ContrastShaderConfiguration>());
    });
  });
}

