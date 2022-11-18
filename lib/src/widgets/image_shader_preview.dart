part of flutter_image_filters;

class ImageShaderPreview extends StatelessWidget {
  final ShaderConfiguration configuration;
  final Future<FragmentProgram> Function()? fragmentProgramProvider;
  final TextureSource texture;

  const ImageShaderPreview({
    Key? key,
    required this.configuration,
    required this.texture,
  })  : fragmentProgramProvider = null,
        super(key: key);

  const ImageShaderPreview.custom({
    Key? key,
    required this.configuration,
    required this.texture,
    this.fragmentProgramProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<FragmentProgram>(
        future: fragmentProgramProvider?.call() ??
            _fragmentPrograms[configuration.runtimeType]?.call(),
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
                  ImageShaderPainter(shaderProgram, texture, configuration),
            ),
          );
        }),
      ),
    );
  }
}
