part of '../../flutter_image_filters.dart';

/// Describes generic shader configuration
abstract class ShaderConfiguration extends FilterConfiguration {
  final List<double> _floats;
  bool _needRedraw = true;
  FragmentProgram? _internalProgram;

  ShaderConfiguration(this._floats);

  /// Prepares the shader program
  ///
  /// This method is called before the first usage of the shader program
  @override
  FutureOr<void> prepare() async {
    _internalProgram ??= await _fragmentPrograms[runtimeType]?.call();
  }

  /// Disposes the shader program
  ///
  /// This method is called when the shader program is no longer needed
  @override
  FutureOr<void> dispose() {
    _internalProgram?.fragmentShader().dispose();
    _internalProgram = null;
  }

  /// Updates the shader program
  ///
  /// This method is called when the shader program needs to be updated
  @override
  FutureOr<void> update() {}

  /// Returns the readiness of the shader program
  @override
  bool get ready => _internalProgram != null;

  /// Returns all shader uniforms. Order of items in array must be as listed in fragment shader code
  Iterable<double> get numUniforms => _floats;

  bool get needRedraw {
    final result = _needRedraw;
    _needRedraw = false;
    return result;
  }

  /// Exports date to an image
  ///
  /// [texture] - source texture
  /// [size] - size of the output image
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

  /// Returns all shader parameters
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
  bool get needRedraw => _configurations.map((e) => e.needRedraw).any((e) => e);

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

  @override
  bool get needRedraw => _configurations.map((e) => e.needRedraw).any((e) => e);

  BunchShaderConfiguration(this._configurations) : super(<double>[]);

  T configuration<T extends ShaderConfiguration>({required int at}) =>
      _configurations[at] as T;

  Iterable<T> configurations<T extends ShaderConfiguration>() =>
      _configurations.whereType<T>();

  @override
  List<ConfigurationParameter> get parameters =>
      _configurations.map((e) => e.parameters).expand((e) => e).toList();
}
