part of flutter_image_filters;

class ImageShaderPainter extends CustomPainter {
  ImageShaderPainter(
    this._fragmentProgram,
    this._texture,
    this._configuration,
  );

  final ShaderConfiguration _configuration;
  final TextureSource _texture;
  final FragmentProgram _fragmentProgram;

  @override
  void paint(Canvas canvas, Size size) {
    final aspectParameter =
        _configuration.parameters.whereType<AspectRatioParameter>().firstOrNull;
    if (aspectParameter != null) {
      aspectParameter.value = size;
      aspectParameter.update(_configuration);
    }
    final floatUniforms = Float32List.fromList(
      [..._configuration.numUniforms, size.width, size.height],
    );

    final textures = [
      _texture,
      ..._configuration.parameters
          .whereType<TextureParameter>()
          .map((e) => e.textureSource)
          .whereType<TextureSource>()
    ];
    final paint = Paint()
      ..color = Colors.orangeAccent
      ..shader = _fragmentProgram.shader(
        floatUniforms: floatUniforms,
        samplerUniforms: textures.map((e) => e.image).toList(),
      );

    /// Draw a rectangle with the shader-paint
    var vertices = Vertices(
      VertexMode.triangleStrip,
      [
        Offset(0, size.height),
        Offset(size.width, size.height),
        const Offset(0, 0),
        Offset(size.width, 0)
      ],
      textureCoordinates: [
        Offset(0, size.height),
        Offset(size.width, size.height),
        const Offset(0, 0),
        Offset(size.width, 0)
      ],
    );
    canvas.drawVertices(vertices, BlendMode.src, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is ImageShaderPainter &&
        oldDelegate._configuration == _configuration) {
      return false;
    }
    return true;
  }
}
