part of flutter_image_filters;

/// Describes Color Parameter updating
class ShaderColorParameter extends ColorParameter {
  final int _offset;

  ShaderColorParameter(
    super.shaderName,
    super.displayName,
    super.value,
    this._offset,
  );

  /// Updates the Color Parameter value.
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
        value.red / 255.0 * value.opacity,
        value.green / 255.0 * value.opacity,
        value.blue / 255.0 * value.opacity,
      ];
}

/// Describes Number Parameter updating
class ShaderNumberParameter extends NumberParameter {
  final int _offset;

  ShaderNumberParameter(
    super.shaderName,
    super.displayName,
    super.value,
    this._offset,
  );

  /// Updates the Number Parameter value.
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

/// Describes Range Parameter updating
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

  /// Updates the Range Parameter value.
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

/// Describes Point Parameter updating
class ShaderPointParameter extends PointParameter {
  final int _offset;

  ShaderPointParameter(
    super.name,
    super.displayName,
    super.value,
    this._offset,
  );

  /// Updates the Point Parameter value.
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

/// Describes Matrix Parameter updating
class ShaderMatrix4Parameter extends Mat4Parameter {
  final int _offset;

  ShaderMatrix4Parameter(
    super.name,
    super.displayName,
    super.value,
    this._offset,
  );

  /// Updates the Matrix Parameter value.
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

/// Describes AspectRatio Parameter updating
class _AspectRatioParameter extends AspectRatioParameter {
  final int _offset;

  _AspectRatioParameter(
    super.name,
    super.displayName,
    super.value,
    this._offset,
  );

  /// Updates the AspectRatio Parameter value.
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

/// Describes Int Parameter updating
class ShaderIntParameter extends ShaderNumberParameter {
  ShaderIntParameter(
    super.shaderName,
    super.displayName,
    super.value,
    super.offset,
  );

  /// Updates the Int Parameter value.
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

/// Describes Texture Parameter updating
class ShaderTextureParameter extends DataParameter {
  TextureSource? textureSource;

  ShaderTextureParameter(super.name, super.displayName);

  /// Updates the Texture Parameter value.
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
      }
    }
  }
}

/// Describes configuration search by parameters
extension on ConfigurationParameter {
  /// Searches Configuration by Parameters.
  ShaderConfiguration? findByParameter(BunchShaderConfiguration configuration) {
    return configuration._configurations.firstWhereOrNull(
      (conf) =>
          conf.parameters.firstWhereOrNull((parameter) => parameter == this) !=
          null,
    );
  }
}
