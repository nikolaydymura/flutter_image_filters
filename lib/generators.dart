import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart';

import 'annotations.dart';

class BunchShaderConfigurationsGenerator extends Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) async {
    final annotations = library.annotatedWith(
      TypeChecker.typeNamed(
        BunchShaderConfigs,
      ),
    );
    if (annotations.isNotEmpty) {
      final configs = annotations.single.annotation
          .read('configs')
          .listValue
          .map((e) => configFrom(e));
      for (final config in configs) {
        if (config.shaders.isEmpty) {
          continue;
        }
        final target = Directory('${Directory.current.path}/${config.output}');
        await generateShader(
          (id) => buildStep.readAsString(
            AssetId('flutter_image_filters', 'shaders/$id.frag'),
          ),
          config.shaders.map((e) => e.shaderFile).toList(),
          target,
          null,
        );
      }
      return [
        "import 'dart:ui';",
        "import 'package:flutter_image_filters/flutter_image_filters.dart';",
        ...configs.map((e) => e.classBody),
        configs.mainRegisterFunction,
      ].join('\n\n');
    }
    return null;
  }
}

extension on String {
  String get shaderFile {
    switch (this) {
      case 'SquareLookupTableShaderConfiguration':
        return 'lookup';
      case 'HALDLookupTableShaderConfiguration':
        return 'hald_lookup';
      case 'RGBShaderConfiguration':
        return replaceAll('ShaderConfiguration', '').toLowerCase();
      default:
        return replaceAll('ShaderConfiguration', '')
            .replaceAllMapped(
              RegExp(r'[A-Z]'),
              (Match m) => '${m.start == 0 ? '' : '_'}${m.group(0)}',
            )
            .toLowerCase();
    }
  }
}

BunchShaderDescription configFrom(dynamic dartObject) {
  final shaders = dartObject
      .getField('shaders')
      ?.toListValue()
      ?.map((e) => e.toTypeValue()?.getDisplayString())
      .whereType<String>();
  final output = dartObject.getField('output')?.toStringValue() ?? 'shaders';
  return BunchShaderDescription(
    shaders: shaders?.toList() ?? [],
    output: output,
    customName: dartObject.getField('name')?.toStringValue(),
  );
}

extension on Iterable<BunchShaderDescription> {
  String get mainRegisterFunction {
    return ['void registerBunchShaders() {', ...map((e) => e.register), '}']
        .join('\n');
  }
}

extension on BunchShaderDescription {
  String get className {
    final prefix =
        shaders.map((e) => e.replaceAll('ShaderConfiguration', '')).join('');
    return customName ?? '${prefix}ShaderConfiguration';
  }

  String get classBody {
    return '''
      class $className extends BunchShaderConfiguration {
        $className() : super([${shaders.map((e) => '$e()').join(', ')}]);
        
        ${shaders.properties}
      }
    ''';
  }

  String get register {
    return '''
      FlutterImageFilters.register<$className>(
        () => FragmentProgram.fromAsset('$output/${shaders.assetPath}.frag'),
      );
    ''';
  }
}

extension on Iterable<String> {
  String get assetPath {
    return map(
      (e) => e.shaderFile,
    ).join('_').toLowerCase();
  }

  String get properties {
    final results = <String>[];
    for (int i = 0; i < length; i++) {
      final value = elementAt(i);
      final name =
          '${value[0].toLowerCase()}${value.replaceAll('ShaderConfiguration', 'Shader').substring(1)}';
      final indexDuplicate = results.where((e) => e.contains(name)).length;
      if (indexDuplicate == 0) {
        results.add('$value get $name => configuration(at: $i);');
      } else {
        results
            .add('$value get $name$indexDuplicate => configuration(at: $i);');
      }
    }
    return results.join('\n\n');
  }
}

class BunchShaderDescription {
  final String output;
  final List<String> shaders;
  final String? customName;

  const BunchShaderDescription({
    required this.output,
    required this.shaders,
    this.customName,
  });
}

Future<void> generateShader(
  Future<String> Function(String) shaderContent,
  List<String> shaders,
  Directory targetFolder,
  String? customSourcesFolder,
) async {
  List<String> finalShader = [
    '#include <flutter/runtime_effect.glsl>',
    'precision mediump float;',
    '\n',
    'out vec4 fragColor;',
  ];
  List<String> shaderSamplers = ['uniform sampler2D inputImageTexture;'];
  List<String> shaderInputs = [];
  List<String> processFunctions = [];
  List<String> shaderConstants = [];
  for (String shader in shaders) {
    try {
      processShader(
        await shaderContent(shader),
        shaderInputs,
        shaderSamplers,
        processFunctions,
        shaderConstants,
      );
    } catch (e, t) {
      stderr.writeln(e);
      stderr.writeln(t);
      continue;
    }
  }
  shaderInputs.add(
    'layout(location = ${shaderInputs.length}) uniform vec2 screenSize;',
  );

  finalShader.add('\n');
  finalShader.addAll(shaderSamplers);
  finalShader.add('\n');
  finalShader.addAll(shaderInputs);
  finalShader.add('\n');
  finalShader.addAll(shaderConstants);
  finalShader.add('\n');
  finalShader.addAll(processFunctions);
  finalShader.add('\n');
  finalShader.add('void main(){');
  finalShader
      .add('\tvec2 textureCoordinate = FlutterFragCoord().xy / screenSize;');
  finalShader.add(
    '\tvec4 textureColor = texture(inputImageTexture, textureCoordinate);',
  );
  late String lastResult;
  for (final func in processFunctions) {
    if (func.startsWith('vec4 processColor')) {
      final funcName = func.split('(').first.split(' ').last.trim();
      final index =
          int.parse(func.replaceAll('vec4', '').replaceAll(RegExp(r'\D'), ''));
      final arguments = [
        index == 0 ? 'textureColor' : lastResult,
        ...func
            .replaceAll('vec4 processColor(', '')
            .replaceAll(')', '')
            .replaceAll('{', '')
            .trim()
            .split(',')
            .map((e) => e.split(' ').last.trim())
            .skip(1),
      ];
      lastResult = funcName.replaceAll('processColor', 'processedColor');
      finalShader.add(
        '\tvec4 $lastResult = $funcName(${arguments.join(', ')});',
      );
    }
  }
  finalShader.add(
    '\tfragColor = $lastResult;',
  );
  finalShader.add('}');
  if (await targetFolder.exists() == false) {
    await targetFolder.create(recursive: true);
  }
  final outputFile =
      File('${targetFolder.absolute.path}/${shaders.join('_')}.frag');
  outputFile.writeAsStringSync(
    finalShader.join('\n').replaceAll(RegExp('\n{3,}'), '\n\n'),
  );
}

void processShader(
  String shaderBody,
  List<String> finalInputs,
  List<String> samplers,
  List<String> processFunctions,
  List<String> shaderConstants,
) {
  List<String> shaderLines = shaderBody
      .split(RegExp('\n+', multiLine: true))
      .whereNot((e) => e.trim().isEmpty)
      .whereNot((e) => e.startsWith('#'))
      .whereNot((e) => e.startsWith('precision'))
      .toList();
  bool processFound = false;
  bool mainFound = false;
  for (final element in shaderLines) {
    if (element.endsWith('fragColor;')) {
      continue;
    }
    if (element.startsWith('layout') || element.startsWith('uniform')) {
      if (element.endsWith('screenSize;') ||
          element.endsWith('inputImageTexture;')) {
        continue;
      }
      if (element.contains('sampler2D')) {
        samplers.add(element);
      } else {
        final start = element.lastIndexOf('uniform') + 8;
        finalInputs.add(
          'layout(location = ${finalInputs.length}) uniform ${element.substring(
            start,
          )}',
        );
      }
      continue;
    }

    if (element.startsWith('vec4 processColor')) {
      final index = processFunctions
          .where((element) => element.startsWith('vec4 processColor'))
          .length;
      final arguments = element
          .replaceAll('vec4 processColor(', '')
          .replaceAll(')', '')
          .replaceAll('{', '')
          .trim();
      processFunctions.add('vec4 processColor$index($arguments){');
      processFound = true;
      continue;
    }
    if (element.startsWith('}')) {
      if (processFound) {
        processFunctions.add(element);
        processFound = false;
        continue;
      } else if (mainFound) {
        mainFound = false;
        continue;
      }
    }
    if (processFound) {
      processFunctions.add(element);
      continue;
    }

    if (element.startsWith('void main')) {
      mainFound = true;
    }

    if (mainFound) {
      continue;
    }

    if (element
        .contains('luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);')) {
      if (shaderConstants.contains(element)) {
        continue;
      }
    }

    shaderConstants.add(element);
  }
}
