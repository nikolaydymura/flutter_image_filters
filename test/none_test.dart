import 'dart:io';

import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  final configuration = NoneShaderConfiguration();

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });
  group('NoneShaderConfiguration', () {
    test('none default', () async {
      await expectFilteredSuccessfully(
        configuration,
        texture,
        'none_default.jpeg',
      );
    });
  });
}
