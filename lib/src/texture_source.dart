part of image_filters;

class TextureSource {
  final ImageShader image;
  final int width;
  final int height;

  TextureSource._(this.image, this.width, this.height);

  static Future<TextureSource> fromAsset(String asset) async {
    final imageData = await rootBundle.load(asset);
    final image = await decodeImageFromList(imageData.buffer.asUint8List());
    return TextureSource._(
      ImageShader(
        image,
        TileMode.repeated,
        TileMode.repeated,
        Matrix4.identity().storage,
      ),
      image.width,
      image.height,
    );
  }

  static Future<TextureSource> fromFile(File file) async {
    final imageData = await file.readAsBytes();
    final image = await decodeImageFromList(imageData.buffer.asUint8List());
    return TextureSource._(
      ImageShader(
        image,
        TileMode.repeated,
        TileMode.repeated,
        Matrix4.identity().storage,
      ),
      image.width,
      image.height,
    );
  }

  static Future<TextureSource> fromMemory(Uint8List data) async {
    final image = await decodeImageFromList(data);
    return TextureSource._(
      ImageShader(
        image,
        TileMode.repeated,
        TileMode.repeated,
        Matrix4.identity().storage,
      ),
      image.width,
      image.height,
    );
  }
}
