import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

import 'fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromFile(inputFile);
  });

  test('export all', skip: true, () async {
    for (final name in FlutterImageFilters.availableFilters) {
      final configuration = FlutterImageFilters.createFilter(displayName: name);
      if (configuration == null) {
        continue;
      }
      if (configuration is SquareLookupTableShaderConfiguration) {
        await configuration.setLutFile(File('demos/lookup_amatorka.png'));
      }
      if (configuration is HALDLookupTableShaderConfiguration) {
        await configuration.setLutFile(File('demos/lookup_hald.png'));
      }
      final output = File('demos/$name.jpg');
      final size =
          Size(texture.width.toDouble(), texture.height.toDouble()) / 3;
      final watch = Stopwatch();
      watch.start();
      final image = await configuration.export(texture, size);
      final bytes = await image.toByteData();
      debugPrint(
        'Exporting image took ${watch.elapsedMilliseconds} milliseconds',
      );
      if (bytes == null) {
        continue;
      }
      final persistedImage = img.Image.fromBytes(
        width: image.width,
        height: image.height,
        bytes: bytes.buffer,
        numChannels: 4,
      );
      img.JpegEncoder encoder = img.JpegEncoder();
      final data = encoder.encode(persistedImage);
      await output.writeAsBytes(data);
      debugPrint(
        'Exporting file took ${watch.elapsedMilliseconds} milliseconds',
      );
      debugPrint('Exported: ${output.absolute}');
    }
  });
  test('configuration not present', () async {
    final configuration = InvalidConfiguration();
    final size = Size(texture.width.toDouble(), texture.height.toDouble()) / 3;
    expect(
      () => configuration.export(texture, size),
      throwsA(
        isA<UnsupportedError>().having(
          (p0) => p0.toString(),
          'configuration not defined',
          'Unsupported operation: Invalid shader for InvalidConfiguration',
        ),
      ),
    );
  });
  test('custom configuration', () async {
    final configuration = InvalidConfiguration();
    FlutterImageFilters.register<InvalidConfiguration>(
      () => FragmentProgram.fromAsset('invalid.frag'),
      override: true,
    );
    final size = Size(texture.width.toDouble(), texture.height.toDouble()) / 3;
    expect(
      () => configuration.export(
        texture,
        size,
      ),
      throwsA(
        isA<Exception>().having(
          (p0) => p0.toString(),
          'asset not provided',
          "Exception: Asset 'invalid.frag' not found",
        ),
      ),
    );
  });
}
