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
  group('SquareLookupTableShaderConfiguration', () {
    test('8x8', () async {
      final configuration = SquareLookupTableShaderConfiguration();
      await configuration.setLutFile(File('demos/lookup_amatorka.png'));
      await expectFilteredSuccessfully(
        configuration,
        texture,
        '8x8.jpeg',
      );
    });
    test('8x8 0.5 intensity', () async {
      final configuration = SquareLookupTableShaderConfiguration();
      configuration.intensity = 0.5;
      final bytes = await File('demos/lookup_amatorka.png').readAsBytes();
      await configuration.setLutImage(bytes);
      await expectFilteredSuccessfully(
        configuration,
        texture,
        '8x8_0.5.jpeg',
      );
    });
    test('asset not found', () async {
      final configuration = SquareLookupTableShaderConfiguration();
      expect(
        () => configuration.setLutAsset('demos/lookup_amatorka.png'),
        throwsA(
          isA<Exception>().having(
            (p0) => p0.toString(),
            'LUT from asset',
            'Exception: Asset not found',
          ),
        ),
      );
    });
  });
  group('HALDLookupTableShaderConfiguration', () {
    test('8x64', () async {
      final configuration = HALDLookupTableShaderConfiguration();
      final bytes = await File('demos/lookup_hald.png').readAsBytes();
      await configuration.setLutImage(bytes);

      await expectFilteredSuccessfully(
        configuration,
        texture,
        '8x64.jpeg',
      );
    });
    test('8x64 0.5 intensity', () async {
      final configuration = HALDLookupTableShaderConfiguration();
      await configuration.setLutFile(File('demos/lookup_hald.png'));
      await expectFilteredSuccessfully(
        configuration,
        texture,
        '8x64_0.5.jpeg',
      );
    });
    test('asset not found', () async {
      final configuration = HALDLookupTableShaderConfiguration();
      expect(
        () => configuration.setLutAsset('demos/lookup_amatorka.png'),
        throwsA(
          isA<Exception>().having(
            (p0) => p0.toString(),
            'LUT from asset',
            'Exception: Asset not found',
          ),
        ),
      );
    });
  });
}
