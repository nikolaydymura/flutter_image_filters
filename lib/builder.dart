import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'generators.dart';

Builder flutterImageFiltersBuilder(BuilderOptions options) {
  return LibraryBuilder(
    BunchShaderConfigurationsGenerator(),
    generatedExtension: '.config.dart',
  );
}
