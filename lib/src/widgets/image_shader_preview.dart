part of flutter_image_filters;

class ImageShaderPreview extends StatelessWidget {
  final ShaderConfiguration configuration;
  final TextureSource texture;
  final BlendMode blendMode;

  const ImageShaderPreview({
    super.key,
    required this.configuration,
    required this.texture,
    this.blendMode = BlendMode.src,
  });

  @override
  Widget build(BuildContext context) {
    final cachedProgram = configuration._cachedProgram;
    if (cachedProgram != null) {
      return SizedBox.expand(
        child: CustomPaint(
          painter: ImageShaderPainter(
            cachedProgram,
            texture,
            configuration,
            blendMode: blendMode,
          ),
        ),
      );
    }
    return FutureBuilder<FragmentProgram?>(
      future: configuration._loadProgram,
      builder: ((context, snapshot) {
        if (snapshot.hasError && kDebugMode) {
          return SingleChildScrollView(
            child: Text(snapshot.error.toString()),
          );
        }
        final shaderProgram = snapshot.data;
        if (shaderProgram == null) {
          return const CircularProgressIndicator();
        }

        return SizedBox.expand(
          child: CustomPaint(
            painter: ImageShaderPainter(
              shaderProgram,
              texture,
              configuration,
              blendMode: blendMode,
            ),
          ),
        );
      }),
    );
  }
}
