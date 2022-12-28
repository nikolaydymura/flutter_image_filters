import 'dart:io';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/src/buffer_matcher.dart';
import 'package:image/image.dart' as img;

Future<void> expectFilteredSuccessfully(
  ShaderConfiguration configuration,
  TextureSource texture,
  String goldenKey, {
  String? configurationKey,
}) async {
  final image = await configuration.export(texture, texture.size);
  final bytes = await image.toByteData();

  expect(bytes, isNotNull);

  final persistedImage = img.Image.fromBytes(
    image.width,
    image.height,
    bytes!.buffer.asUint8List(),
  );
  img.JpegEncoder encoder = img.JpegEncoder();
  final data = encoder.encodeImage(persistedImage);
  final output = File(
    'test/goldens/shaders/${configurationKey ?? configuration.runtimeType}/$goldenKey',
  );
  await expectLater(data, bufferMatchesGoldenFile(output.absolute.path));
}
