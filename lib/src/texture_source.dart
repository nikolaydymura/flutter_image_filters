part of flutter_image_filters;

class TextureSource {
  final ImageShader image;
  final int width;
  final int height;

  Size get size => Size(width.toDouble(), height.toDouble());

  TextureSource._(this.image, this.width, this.height);

  static Future<TextureSource> fromAsset(
    String asset, {
    TileMode tmx = TileMode.repeated,
    TileMode tmy = TileMode.repeated,
  }) async {
    final buffer = await ImmutableBuffer.fromAsset(asset);
    return await _fromImmutableBuffer(buffer, tmx, tmy);
  }

  static Future<TextureSource> fromFile(
    File file, {
    TileMode tmx = TileMode.repeated,
    TileMode tmy = TileMode.repeated,
  }) async {
    final data = await file.readAsBytes();
    final buffer = await ImmutableBuffer.fromUint8List(data);
    return _fromImmutableBuffer(buffer, tmx, tmy);
  }

  static Future<TextureSource> fromMemory(
    Uint8List data, {
    TileMode tmx = TileMode.repeated,
    TileMode tmy = TileMode.repeated,
  }) async {
    final buffer = await ImmutableBuffer.fromUint8List(data);

    return await _fromImmutableBuffer(buffer, tmx, tmy);
  }

  static Future<TextureSource> _fromImmutableBuffer(
    ImmutableBuffer buffer,
    TileMode tmx,
    TileMode tmy,
  ) async {
    final codec =
        await PaintingBinding.instance.instantiateImageCodecFromBuffer(buffer);
    final frameInfo = await codec.getNextFrame();

    final image = frameInfo.image;
    return TextureSource._(
      ImageShader(
        image,
        tmx,
        tmy,
        Matrix4.identity().storage,
      ),
      image.width,
      image.height,
    );
  }
}
