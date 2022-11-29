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
  group('LookupTableShaderConfiguration', () {
    test('8x8', () async {
      final configuration = LookupTableShaderConfiguration();
      await configuration.setLutFile(File('demos/lookup_amatorka.png'));
      await expectFilteredSuccessfully(
        configuration,
        texture,
        '8x8.jpeg',
      );
    });
    test('8x8 0.5 intensity', () async {
      final configuration = LookupTableShaderConfiguration();
      configuration.intensity = 0.5;
      await configuration.setLutFile(File('demos/lookup_amatorka.png'));
      await expectFilteredSuccessfully(
        configuration,
        texture,
        '8x8_0.5.jpeg',
      );
    });
    test('8x64', () async {
      final configuration = LookupTableShaderConfiguration.size8x64();
      final bytes = await File('demos/lookup_hald.png').readAsBytes();
      await configuration.setLutImage(bytes);

      await expectFilteredSuccessfully(
        configuration,
        texture,
        '8x64.jpeg',
      );
    });
    test('16x1', () async {
      final configuration = LookupTableShaderConfiguration.size16x1();
      await configuration.setLutFile(File('demos/lookup_line.png'));

      await expectFilteredSuccessfully(
        configuration,
        texture,
        '16x1.jpeg',
      );
    });
    test('16x1 to 8x8', () async {
      final configuration = LookupTableShaderConfiguration.size16x1();
      configuration.size = 8;
      configuration.columns = 8;
      configuration.rows = 8;
      await configuration.setLutFile(File('demos/lookup_amatorka.png'));

      await expectFilteredSuccessfully(
        configuration,
        texture,
        '8x8.jpeg',
      );
    });
    test('asset not found', () async {
      final configuration = LookupTableShaderConfiguration.size16x1();
      configuration.size = 8;
      configuration.columns = 8;
      configuration.rows = 8;
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
