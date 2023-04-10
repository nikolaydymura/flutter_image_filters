part of flutter_image_filters;

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
    }
  }

  @override
  List<double> get values => [
        value.red / 255.0 * value.opacity,
        value.green / 255.0 * value.opacity,
        value.blue / 255.0 * value.opacity
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
    }
  }
}

class ShaderTextureParameter extends DataParameter {
  TextureSource? textureSource;

  ShaderTextureParameter(super.name, super.displayName);

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
      } else if (file != null) {
        textureSource = await TextureSource.fromFile(file!);
      } else if (data != null) {
        textureSource = await TextureSource.fromMemory(data!);
      }
    }
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
