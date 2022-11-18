part of flutter_image_filters;

class _ColorParameter extends ColorParameter {
  final int _offset;

  _ColorParameter(
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

class _NumberParameter extends NumberParameter {
  final int _offset;

  _NumberParameter(
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

class _RangeNumberParameter extends RangeNumberParameter {
  final int _offset;

  _RangeNumberParameter(
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

class _SizeParameter extends SizeParameter {
  final int _offset;

  _SizeParameter(super.name, super.displayName, super.value, this._offset);

  @override
  void update(covariant ShaderConfiguration configuration) {
    final size = value;
    configuration._floats[_offset] = size.width;
    configuration._floats[_offset + 1] = size.height;
  }
}

class _PointParameter extends PointParameter {
  final int _offset;

  _PointParameter(
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

class _Matrix4Parameter extends Matrix4Parameter {
  final int _offset;

  _Matrix4Parameter(
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
    configuration._floats[_offset] = value.width / value.height;
  }
}

class _IntParameter extends _NumberParameter {
  _IntParameter(
    super.shaderName,
    super.displayName,
    super.value,
    super.offset,
  );

  @override
  void update(covariant ShaderConfiguration configuration) {
    configuration._floats[_offset] = value.toInt().toDouble();
  }
}

class TextureParameter extends DataParameter {
  TextureSource? textureSource;

  TextureParameter(super.name, super.displayName);

  @override
  FutureOr<void> update(covariant ShaderConfiguration configuration) async {
    if (asset != null) {
      textureSource = await TextureSource.fromAsset(asset!);
    } else if (file != null) {
      textureSource = await TextureSource.fromFile(file!);
    } else if (data != null) {
      textureSource = await TextureSource.fromMemory(data!);
    }
  }
}
