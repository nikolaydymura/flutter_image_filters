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

  String get uniformName => split(' ').last.replaceAll(';', '').trim();
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
  final content = <ShaderBody>[];
  for (String shader in shaders) {
    try {
      content.add(ShaderBody.fromSource(await shaderContent(shader)));
    } catch (e, t) {
      stderr.writeln(e);
      stderr.writeln(t);
      continue;
    }
  }
  finalShader.add('\n');
  finalShader.addAll(content.samplers);
  finalShader.add('\n');
  finalShader.addAll(content.inputs);
  finalShader.add('\n');
  finalShader.addAll(content.others);
  finalShader.add('\n');
  finalShader.addAll(content.process);
  finalShader.add('\n');
  finalShader.addAll(content.main);
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
          'uniform ${element.substring(
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

class ShaderBody {
  final List<String> inputs;
  final List<String> samplers;
  final List<String> process;
  final List<String> others;

  ShaderBody({
    this.inputs = const [],
    this.samplers = const [],
    this.process = const [],
    this.others = const [],
  });

  factory ShaderBody.fromSource(String body) {
    List<String> inputs = [];
    List<String> samplers = [];
    List<String> process = [];
    List<String> others = [];

    List<String> shaderLines = body
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
            element.endsWith('inputImageTexture;') ||
            element.endsWith('textureSize;')) {
          continue;
        }
        if (element.contains('sampler2D')) {
          samplers.add(element);
        } else {
          final start = element.lastIndexOf('uniform') + 8;
          inputs.add(
            'uniform ${element.substring(
              start,
            )}',
          );
        }
        continue;
      }

      if (element.startsWith('vec4 processColor')) {
        process.add(element);

        processFound = true;
        continue;
      }
      if (element.startsWith('}')) {
        if (processFound) {
          process.add(element);
          processFound = false;
          continue;
        } else if (mainFound) {
          mainFound = false;
          continue;
        }
      }
      if (processFound) {
        process.add(element);
        continue;
      }

      if (element.startsWith('void main')) {
        mainFound = true;
      }

      if (mainFound) {
        continue;
      }

      others.add(element);
    }

    return ShaderBody(
      inputs: inputs,
      samplers: samplers,
      process: process,
      others: others,
    );
  }
}

extension on Iterable<ShaderBody> {
  Iterable<String> get samplers {
    return [
      'uniform sampler2D inputImageTexture;',
      ...expand((e) => e.samplers),
    ];
  }

  Iterable<String> get inputs {
    final samplers =
        expand((e) => e.samplers).map((e) => e.uniformName).toSet();
    return [
      ...expand((e) => e.inputs)
          .whereNot((e) => samplers.any((s) => e.uniformName.startsWith(s))),
      ...expand((e) => e.samplers)
          .map((e) => 'uniform vec2 ${e.uniformName}Size;'),
      'uniform vec2 screenSize;',
    ].mapIndexed((i, e) => 'layout(location = $i) $e');
  }

  Iterable<String> get process {
    return mapIndexed((index, value) {
      return value.process.map((e) {
        if (e.startsWith('vec4 processColor')) {
          final arguments = e
              .replaceAll('vec4 processColor(', '')
              .replaceAll(')', '')
              .replaceAll('{', '')
              .trim();
          return 'vec4 processColor$index($arguments){';
        }
        return e;
      });
    }).expand((e) => e);
  }

  Iterable<String> get others {
    final others = expand((e) => e.others);
    if (others
            .where(
              (e) => e.contains(
                'luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);',
              ),
            )
            .length >
        1) {
      final found = others.firstWhere(
        (e) => e.contains('luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);'),
      );
      return [
        found,
        ...others.whereNot(
          (e) =>
              e.contains('luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);'),
        ),
      ];
    }
    return others;
  }

  Iterable<String> get main {
    final output = <String>[];
    output.add('void main(){');
    output
        .add('\tvec2 textureCoordinate = FlutterFragCoord().xy / screenSize;');
    output.add(
      '\tvec4 textureColor = texture(inputImageTexture, textureCoordinate);',
    );
    late String lastResult;
    for (final func in process) {
      if (func.startsWith('vec4 processColor')) {
        final funcName = func.split('(').first.split(' ').last.trim();
        final index = int.parse(
          func.replaceAll('vec4', '').replaceAll(RegExp(r'\D'), ''),
        );
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
        output.add(
          '\tvec4 $lastResult = $funcName(${arguments.join(', ')});',
        );
      }
    }
    output.add(
      '\tfragColor = $lastResult;',
    );
    output.add('}');
    return output;
  }
}
