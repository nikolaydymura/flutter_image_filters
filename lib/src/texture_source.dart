part of flutter_image_filters;

class TextureSource {
  final Image image;
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
// coverage:ignore-start
    return await _fromImmutableBuffer(buffer, tmx, tmy);
// coverage:ignore-end
  }

  static Future<TextureSource> fromFile(
    File file, {
    TileMode tmx = TileMode.repeated,
    TileMode tmy = TileMode.repeated,
  }) async {
    final buffer = await ImmutableBuffer.fromFilePath(file.path);
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

  static TextureSource fromImage(
    Image image, {
    TileMode tmx = TileMode.repeated,
    TileMode tmy = TileMode.repeated,
  }) {
    return TextureSource._(
      image,
      image.width,
      image.height,
    );
  }

  static Future<TextureSource> _fromImmutableBuffer(
    ImmutableBuffer buffer,
    TileMode tmx,
    TileMode tmy,
  ) async {
    final codec =
        await PaintingBinding.instance.instantiateImageCodecWithSize(buffer);
    final frameInfo = await codec.getNextFrame();

    return fromImage(frameInfo.image, tmx: tmx, tmy: tmy);
  }
}
