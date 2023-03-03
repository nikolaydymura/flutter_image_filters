part of flutter_image_filters;

abstract class ShaderConfiguration extends FilterConfiguration {
  final List<double> _floats;
  FragmentProgram? _internalProgram;

  ShaderConfiguration(this._floats);

  @override
  FutureOr<void> prepare() async {
    _internalProgram ??= await _fragmentPrograms[runtimeType]?.call();
  }

  @override
  FutureOr<void> dispose() {
    _internalProgram?.fragmentShader().dispose();
    _internalProgram = null;
  }

  @override
  FutureOr<void> update() {}

  @override
  bool get ready => _internalProgram != null;

  /// Returns all shader uniforms. Order of items in array must be as listed in fragment shader code
  Iterable<double> get numUniforms => _floats;

  Future<Image> export(
    TextureSource texture,
    Size size,
  ) async {
// coverage:ignore-start
    if (kIsWeb) {
      throw UnsupportedError('Not supported for web');
    }
// coverage:ignore-end
    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);
    if (!ready) {
      await prepare();
    }
    final fragmentProgram = _internalProgram;
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

class GroupShaderConfiguration extends ShaderConfiguration {
  final Set<ShaderConfiguration> _configurations = {};
  final Map<ShaderConfiguration, Image> _cache = {};
  final Map<ShaderConfiguration, List<double>> _cacheUniforms = {};
  final ShaderConfiguration _configuration = NoneShaderConfiguration();

  GroupShaderConfiguration() : super(<double>[]);

  @override
  FragmentProgram? get _internalProgram => _configuration._internalProgram;

  @override
  FutureOr<void> prepare() => _configuration.prepare();

  @override
  FutureOr<void> update() => _configuration.update();

  @override
  FutureOr<void> dispose() => _configuration.dispose();

  void add(ShaderConfiguration configuration) {
    _configurations.add(configuration);
  }

  void remove(ShaderConfiguration configuration) {
    _configurations.remove(configuration);
    _cache.remove(configuration);
  }

  void clear() {
    _configurations.clear();
    _cache.clear();
  }

  @override
  Future<Image> export(
    TextureSource texture,
    Size size,
  ) async {
    if (_configurations.isEmpty) {
      throw UnsupportedError('Group is empty');
    }
    late Image result;
    for (final configuration in _configurations) {
      final uniforms = _cacheUniforms[configuration];
      if (uniforms != null) {
        final changed = !listEquals(uniforms, configuration._floats);
        if (changed) {
          bool found = false;
          for (final c in _configurations) {
            if (c == configuration) {
              found = true;
            }
            if (found) {
              _cache.remove(c);
            }
          }
        }
      }
      _cacheUniforms[configuration] = [...configuration._floats];
      result = (_cache[configuration] ??= await configuration.export(
        texture,
        size,
      ));
      if (_configurations.length > 1) {
        texture = TextureSource.fromImage(result);
      }
    }
    return result;
  }
}

class BunchShaderConfiguration extends ShaderConfiguration {
  final List<ShaderConfiguration> _configurations;

  @override
  Iterable<double> get numUniforms =>
      _configurations.map((e) => e.numUniforms).expand((e) => e);

  BunchShaderConfiguration(this._configurations) : super(<double>[]);

  T configuration<T extends ShaderConfiguration>({required int at}) =>
      _configurations[at] as T;

  @override
  List<ConfigurationParameter> get parameters =>
      _configurations.map((e) => e.parameters).expand((e) => e).toList();
}
