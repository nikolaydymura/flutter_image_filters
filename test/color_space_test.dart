import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ColorSpaceCorrection', () {
    test('gammaToLinear conversion', () {
      final result = ColorSpaceCorrection.gammaToLinear(0.5);
      expect(result, isA<double>());
      expect(result, greaterThan(0.0));
      expect(result, lessThan(1.0));
    });

    test('linearToGamma conversion', () {
      final result = ColorSpaceCorrection.linearToGamma(0.5);
      expect(result, isA<double>());
      expect(result, greaterThan(0.0));
      expect(result, lessThan(1.0));
    });

    test('color space correction for list', () {
      final colors = [0.1, 0.5, 0.9];
      final corrected = ColorSpaceCorrection.correctColorSpace(colors);
      expect(corrected, isA<List<double>>());
      expect(corrected.length, equals(colors.length));
    });

    test('brightness configuration creation', () {
      final config = BrightnessShaderConfiguration();
      config.brightness = 0.3;
      // Verify the configuration was created successfully
      expect(config, isA<BrightnessShaderConfiguration>());
    });

    test('contrast configuration creation', () {
      final config = ContrastShaderConfiguration();
      config.contrast = 1.5;
      // Verify the configuration was created successfully
      expect(config, isA<ContrastShaderConfiguration>());
    });
  });
}
