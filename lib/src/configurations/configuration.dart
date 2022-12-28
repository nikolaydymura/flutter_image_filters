part of flutter_image_filters;

abstract class ShaderConfiguration extends FilterConfiguration {
  final List<double> _floats;
  FragmentProgram? _cachedProgram;

  ShaderConfiguration(this._floats);

  /// Returns all shader uniforms. Order of items in array must be as listed in fragment shader code
  Iterable<double> get numUniforms => _floats;

  Future<FragmentProgram?> get _loadProgram async =>
      (_cachedProgram ??= await _fragmentPrograms[runtimeType]?.call());

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
    final fragmentProgram = await _loadProgram;
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
  FragmentProgram? get _cachedProgram => _configuration._cachedProgram;

  @override
  Future<FragmentProgram?> get _loadProgram => _configuration._loadProgram;

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
