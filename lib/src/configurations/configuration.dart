part of flutter_image_filters;

abstract class ShaderConfiguration extends FilterConfiguration {
  final List<double> _floats;

  ShaderConfiguration(this._floats);

  /// Returns all shader uniforms. Order of items in array must be as listed in fragment shader code
  Iterable<double> get numUniforms => _floats;

  Future<Image> export(
    TextureSource texture,
    Size size, {
    Future<FragmentProgram> Function()? fragmentProgramProvider,
  }) async {
// coverage:ignore-start
    if (kIsWeb) {
      throw UnsupportedError('Not supported for web');
    }
// coverage:ignore-end
    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);
    final fragmentProgram = await (fragmentProgramProvider?.call() ??
        _fragmentPrograms[runtimeType]?.call());
    if (fragmentProgram == null) {
      throw UnsupportedError('Invalid shader for $runtimeType');
    }
    final painter = ImageShaderPainter(fragmentProgram, texture, this);

    painter.paint(canvas, size);
    Image renderedImage = await recorder
        .endRecording()
        .toImage(size.width.floor(), size.height.floor());
    return renderedImage;
  }

  @override
  List<ConfigurationParameter> get parameters => [];
}
