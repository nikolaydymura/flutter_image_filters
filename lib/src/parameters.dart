part of '../flutter_image_filters.dart';

class ShaderColorParameter extends ColorParameter {
  final int _offset;

  ShaderColorParameter(
    super.shaderName,
    super.displayName,
    super.value,
    this._offset,
  );

  @override
  FutureOr<void> update(covariant ShaderConfiguration configuration) {
    if (configuration is BunchShaderConfiguration) {
      final conf = findByParameter(configuration);
      if (conf != null) {
        update(conf);
      }
    } else {
      configuration._floats.setAll(_offset, values);
      configuration._needRedraw = true;
    }
  }

  @override
  List<double> get values => [
        value.r / 255.0 * value.a,
        value.g / 255.0 * value.a,
        value.b / 255.0 * value.a,
      ];
}

class ShaderNumberParameter extends NumberParameter {
  final int _offset;

  ShaderNumberParameter(
    super.shaderName,
    super.displayName,
    super.value,
    this._offset,
  );

  @override
  void update(covariant ShaderConfiguration configuration) {
    if (configuration is BunchShaderConfiguration) {
      final conf = findByParameter(configuration);
      if (conf != null) {
        update(conf);
      }
    } else {
      configuration._floats[_offset] = floatValue;
      configuration._needRedraw = true;
    }
  }
}

class ShaderRangeNumberParameter extends RangeNumberParameter {
  final int _offset;

  ShaderRangeNumberParameter(
    super.shaderName,
    super.displayName,
    super.value,
    this._offset, {
    super.min,
    super.max,
  });

  @override
  void update(covariant ShaderConfiguration configuration) {
    if (configuration is BunchShaderConfiguration) {
      final conf = findByParameter(configuration);
      if (conf != null) {
        update(conf);
      }
    } else {
      configuration._floats[_offset] = floatValue;
      configuration._needRedraw = true;
    }
  }
}

class ShaderPointParameter extends PointParameter {
  final int _offset;

  ShaderPointParameter(
    super.name,
    super.displayName,
    super.value,
    this._offset,
  );

  @override
  void update(covariant ShaderConfiguration configuration) {
    if (configuration is BunchShaderConfiguration) {
      final conf = findByParameter(configuration);
      if (conf != null) {
        update(conf);
      }
    } else {
      configuration._floats.setAll(_offset, values);
      configuration._needRedraw = true;
    }
  }
}

class ShaderMatrix4Parameter extends Mat4Parameter {
  final int _offset;

  ShaderMatrix4Parameter(
    super.name,
    super.displayName,
    super.value,
    this._offset,
  );

  @override
  void update(covariant ShaderConfiguration configuration) {
    if (configuration is BunchShaderConfiguration) {
      final conf = findByParameter(configuration);
      if (conf != null) {
        update(conf);
      }
    } else {
      configuration._floats.setAll(_offset, values);
      configuration._needRedraw = true;
    }
  }
}

class _AspectRatioParameter extends AspectRatioParameter {
  final int _offset;

  _AspectRatioParameter(
    super.name,
    super.displayName,
    super.value,
    this._offset,
  );

  @override
  void update(covariant ShaderConfiguration configuration) {
    if (configuration is BunchShaderConfiguration) {
      final conf = findByParameter(configuration);
      if (conf != null) {
        update(conf);
      }
    } else {
      configuration._floats[_offset] = floatValue;
      configuration._needRedraw = true;
    }
  }
}

class ShaderIntParameter extends ShaderNumberParameter {
  ShaderIntParameter(
    super.shaderName,
    super.displayName,
    super.value,
    super.offset,
  );

  @override
  void update(covariant ShaderConfiguration configuration) {
    if (configuration is BunchShaderConfiguration) {
      final conf = findByParameter(configuration);
      if (conf != null) {
        update(conf);
      }
    } else {
      configuration._floats[_offset] = intValue.toDouble();
      configuration._needRedraw = true;
    }
  }
}

class ShaderTextureParameter extends DataParameter {
  static TextureSource? _emptyTexture;

  TextureSource? _textureSource;

  ShaderTextureParameter(super.name, super.displayName);

  TextureSource? get textureSource => _textureSource ?? _emptyTexture;

  set textureSource(TextureSource? value) {
    _textureSource = value;
  }

  @override
  FutureOr<void> update(covariant ShaderConfiguration configuration) async {
    if (configuration is BunchShaderConfiguration) {
      final conf = findByParameter(configuration);
      if (conf != null) {
        update(conf);
      }
    } else {
      if (asset != null) {
        textureSource = await TextureSource.fromAsset(asset!);
        configuration._needRedraw = true;
      } else if (file != null) {
        textureSource = await TextureSource.fromFile(file!);
        configuration._needRedraw = true;
      } else if (data != null) {
        textureSource = await TextureSource.fromMemory(data!);
        configuration._needRedraw = true;
      } else {
        textureSource = null;
        configuration._needRedraw = true;
      }
    }
  }

  static Future<void> _loadEmptyTexture() async {
    _emptyTexture = await TextureSource.fromAsset(
      'packages/flutter_image_filters/assets/empty_texture.jpg',
    );
  }
}

extension on ConfigurationParameter {
  ShaderConfiguration? findByParameter(BunchShaderConfiguration configuration) {
    return configuration._configurations.firstWhereOrNull(
      (conf) =>
          conf.parameters.firstWhereOrNull((parameter) => parameter == this) !=
          null,
    );
  }
}
