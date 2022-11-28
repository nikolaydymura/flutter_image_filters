import 'dart:io';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = WhiteBalanceShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  group('WhiteBalanceShaderConfiguration', () {
    test('white_balance default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'white_balance_default.jpeg',
      );
    });
    test('white_balance 3000, 0.1', () async {
      configuration.temperature = 3000;
      configuration.tint = 0.1;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'white_balance_3000_0.1.jpeg',
      );
    });
    test('white_balance 5500, 0.2', () async {
      configuration.temperature = 5500;
      configuration.tint = 0.2;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'white_balance_5500_0.2.jpeg',
      );
    });
    test('white_balance 6000, 0.9', () async {
      configuration.temperature = 6000;
      configuration.tint = 0.9;

      await expectFilteredSuccessfully(
        configuration,
        texture,
        'white_balance_6000_0.9.jpeg',
      );
    });
  });
}
