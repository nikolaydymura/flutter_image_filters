part of flutter_image_filters;

class PipelineImageShaderPreview extends StatelessWidget {
  final GroupShaderConfiguration configuration;
  final TextureSource texture;
  final BlendMode blendMode;

  const PipelineImageShaderPreview({
    super.key,
    required this.configuration,
    required this.texture,
    this.blendMode = BlendMode.src,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Image>(
      future: _export(),
      builder: ((context, snapshot) {
        if (snapshot.hasError && kDebugMode) {
          debugPrint(snapshot.error.toString());
          return SingleChildScrollView(
            child: Text(snapshot.error.toString()),
          );
        }
        final image = snapshot.data;
        if (image == null) {
          return const CircularProgressIndicator();
        }
        return ImageShaderPreview(
          configuration: configuration,
          texture: TextureSource.fromImage(image),
        );
      }),
    );
  }

  Future<Image> _export() async {
    if (kDebugMode) {
      final watch = Stopwatch();
      watch.start();
      final result = await configuration.export(texture, texture.size);
      debugPrint(
        'Exporting image took ${watch.elapsedMilliseconds} milliseconds',
      );
      return result;
    } else {
      final result = await configuration.export(texture, texture.size);
      return result;
    }
  }
}
