part of '../../flutter_image_filters.dart';

class ImageShaderPainter extends CustomPainter {
  ImageShaderPainter(
    this._fragmentProgram,
    this._texture,
    this._configuration, {
    this.blendMode = BlendMode.src,
    this.filterQuality = FilterQuality.none,
    this.isAntiAlias = true,
  });

  final BlendMode blendMode;
  final ShaderConfiguration _configuration;
  final TextureSource _texture;
  final FragmentProgram _fragmentProgram;
  final bool isAntiAlias;
  final FilterQuality filterQuality;

  @override
  void paint(Canvas canvas, Size size) {
    final aspectParameter =
        _configuration.parameters.whereType<AspectRatioParameter>().firstOrNull;
    if (aspectParameter != null) {
      aspectParameter.value = size;
      aspectParameter.update(_configuration);
    }

    final additionalTextures = _configuration.parameters
        .whereType<ShaderTextureParameter>()
        .map((e) => e.textureSource);
    final textures = [
      _texture,
      ...additionalTextures.nonNulls,
    ];

    final shader = _fragmentProgram.fragmentShader();

    final additionalSizes = additionalTextures
        .map((e) => [e?.width, e?.height])
        .expand((e) => e)
        .nonNulls
        .map((e) => e.toDouble());
    [..._configuration.numUniforms, ...additionalSizes, size.width, size.height]
        .forEachIndexed((index, value) {
      shader.setFloat(index, value);
    });

    textures.forEachIndexed((index, e) {
      shader.setImageSampler(index, e.image);
    });

    if (additionalTextures.length + 1 == textures.length) {
      final paint = Paint()
        ..shader = shader
        ..isAntiAlias = isAntiAlias
        ..filterQuality = filterQuality;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    } else {
      final paint = Paint()
        ..isAntiAlias = isAntiAlias
        ..filterQuality = filterQuality;
      canvas.drawImageRect(
        textures.first.image,
        Rect.fromLTWH(
          0,
          0,
          textures.first.width.toDouble(),
          textures.first.height.toDouble(),
        ),
        Rect.fromLTWH(0, 0, size.width, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is ImageShaderPainter &&
        oldDelegate._configuration != _configuration) {
      return true;
    }
    return _configuration.needRedraw;
  }
}
