part of flutter_image_filters;

class ImageShaderPreview extends StatelessWidget {
  final ShaderConfiguration configuration;
  final Iterable<TextureSource> textures;

  const ImageShaderPreview({
    Key? key,
    required this.configuration,
    required this.textures,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<FragmentProgram>(
        /// Use the generated loader function here
        future: _shaders[configuration.runtimeType]?.call(),
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
              painter:
                  ImageShaderPainter(shaderProgram, textures, configuration),
            ),
          );
        }),
      ),
    );
  }
}
