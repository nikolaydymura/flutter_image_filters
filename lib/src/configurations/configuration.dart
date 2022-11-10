part of image_filters;

abstract class ShaderConfiguration {
  final List<double> _floats;

  ShaderConfiguration(this._floats);

  List<ShaderParameter> get parameters;

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

abstract class ShaderParameter {
  final String _shaderName;
  final String displayName;
  final int _offset;

  ShaderParameter(this._shaderName, this.displayName, this._offset);

  void update(ShaderConfiguration configuration);

  @override
  String toString() {
    return 'ShaderParameter: $_shaderName => $displayName';
  }
}

class ColorParameter extends ShaderParameter {
  Color value;

  ColorParameter(super.shaderName, super.displayName, super.offset, this.value);

  @override
  void update(ShaderConfiguration configuration) {
    final color = value;
    configuration._floats[_offset] = color.red / 255.0;
    configuration._floats[_offset + 1] = color.green / 255.0;
    configuration._floats[_offset + 2] = color.blue / 255.0;
  }
}

class NumberParameter extends ShaderParameter {
  num value;

  NumberParameter(
    super.shaderName,
    super.displayName,
    super.offset,
    this.value,
  );

  @override
  void update(ShaderConfiguration configuration) {
    configuration._floats[_offset] = value.toDouble();
  }
}

class SliderNumberParameter extends NumberParameter {
  num? min;
  num? max;

  SliderNumberParameter(
    super.shaderName,
    super.displayName,
    super.offset,
    super.value, {
    this.min,
    this.max,
  });

  @override
  void update(ShaderConfiguration configuration) {
    configuration._floats[_offset] = value.toDouble();
  }
}

class SizeParameter extends ShaderParameter {
  Size value;

  SizeParameter(super.shaderName, super.displayName, super.offset, this.value);

  @override
  void update(ShaderConfiguration configuration) {
    final size = value;
    configuration._floats[_offset] = size.width;
    configuration._floats[_offset + 1] = size.height;
  }
}

class PointParameter extends ShaderParameter {
  Point<double> value;

  PointParameter(super.shaderName, super.displayName, super.offset, this.value);

  @override
  void update(ShaderConfiguration configuration) {
    final size = value;
    configuration._floats[_offset] = size.x;
    configuration._floats[_offset + 1] = size.y;
  }
}
