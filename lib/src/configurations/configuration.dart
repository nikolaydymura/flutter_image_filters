part of flutter_image_filters;

abstract class ShaderConfiguration extends FilterConfiguration {
  final List<double> _floats;

  ShaderConfiguration(this._floats);

  Iterable<double> get numUniforms => _floats;

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
    final color = value;
    configuration._floats[_offset] = color.red / 255.0;
    configuration._floats[_offset + 1] = color.green / 255.0;
    configuration._floats[_offset + 2] = color.blue / 255.0;
  }
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
    configuration._floats[_offset] = value.toDouble();
  }
}

class ShaderSliderNumberParameter extends RangeNumberParameter {
  final int _offset;

  ShaderSliderNumberParameter(
    super.shaderName,
    super.displayName,
    super.value,
    this._offset, {
    super.min,
    super.max,
  });

  @override
  void update(covariant ShaderConfiguration configuration) {
    configuration._floats[_offset] = value.toDouble();
  }
}

class ShaderSizeParameter extends SizeParameter {
  final int _offset;

  ShaderSizeParameter(super.name, super.displayName, super.value, this._offset);

  @override
  void update(covariant ShaderConfiguration configuration) {
    final size = value;
    configuration._floats[_offset] = size.width;
    configuration._floats[_offset + 1] = size.height;
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
    final point = value;
    configuration._floats[_offset] = point.x;
    configuration._floats[_offset + 1] = point.y;
  }
}

class ShaderMatrix4Parameter extends Matrix4Parameter {
  final int _offset;

  ShaderMatrix4Parameter(
    super.name,
    super.displayName,
    super.value,
    this._offset,
  );

  @override
  void update(covariant ShaderConfiguration configuration) {
    configuration._floats.setAll(_offset, value.storage);
  }
}

class ShaderAspectRatioParameter extends AspectRatioParameter {
  final int _offset;

  ShaderAspectRatioParameter(
    super.name,
    super.displayName,
    super.value,
    this._offset,
  );

  @override
  void update(covariant ShaderConfiguration configuration) {
    configuration._floats[_offset] = value.width / value.height;
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
  void update(ShaderConfiguration configuration) {
    configuration._floats[_offset] = value.toInt().toDouble();
  }
}
