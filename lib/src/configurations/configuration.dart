part of image_filters;

abstract class ShaderConfiguration {
  Iterable<double> get numUniforms => [];

  Future<Image> exportImage(
    Iterable<TextureSource> textures,
    Size size,
  ) async {
    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);
    final fragmentProgram = await _shaders[runtimeType]?.call();
    if (fragmentProgram == null) {
      throw UnsupportedError('Invalid shader for $runtimeType');
    }
    final painter = ImageShaderPainter(fragmentProgram, textures, this);

    painter.paint(canvas, size);
    Image renderedImage = await recorder
        .endRecording()
        .toImage(size.width.floor(), size.height.floor());
    return renderedImage;
  }
}
