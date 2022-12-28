import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

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
      if (configuration is LookupTableShaderConfiguration) {
        configuration.size = 8;
        configuration.rows = 8;
        configuration.columns = 8;
        await configuration.setLutFile(File('demos/lookup_amatorka.png'));
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
        image.width,
        image.height,
        bytes.buffer.asUint8List(),
      );
      img.JpegEncoder encoder = img.JpegEncoder();
      final data = encoder.encodeImage(persistedImage);
      await output.writeAsBytes(data);
      debugPrint(
        'Exporting file took ${watch.elapsedMilliseconds} milliseconds',
      );
      debugPrint('Exported: ${output.absolute}');
    }
  });
  test('configuration not present', () async {
    final configuration = _InvalidConfiguration();
    final size = Size(texture.width.toDouble(), texture.height.toDouble()) / 3;
    expect(
      () => configuration.export(texture, size),
      throwsA(
        isA<UnsupportedError>().having(
          (p0) => p0.toString(),
          'configuration not defined',
          'Unsupported operation: Invalid shader for _InvalidConfiguration',
        ),
      ),
    );
  });
  test('custom configuration', () async {
    final configuration = _InvalidConfiguration();
    FlutterImageFilters.register<_InvalidConfiguration>(
      () async => DummyFragmentProgram(),
      override: true,
    );
    final size = Size(texture.width.toDouble(), texture.height.toDouble()) / 3;
    expect(
      () => configuration.export(
        texture,
        size,
      ),
      throwsA(
        isA<NoSuchMethodError>(),
      ),
    );
  });
}

class DummyFragmentProgram implements FragmentProgram {
  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

class _InvalidConfiguration extends ShaderConfiguration {
  _InvalidConfiguration() : super([]);
}
