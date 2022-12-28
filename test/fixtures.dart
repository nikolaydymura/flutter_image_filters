import 'dart:ui';

import 'package:flutter_image_filters/flutter_image_filters.dart';

class DummyFragmentProgram implements FragmentProgram {
  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

class InvalidConfiguration extends ShaderConfiguration {
  InvalidConfiguration() : super([]);
}
