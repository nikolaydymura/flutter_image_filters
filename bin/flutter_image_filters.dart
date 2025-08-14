import 'dart:io';

import 'package:collection/collection.dart';

const supported = [
  'brightness',
  'color_invert',
  'color_matrix',
  'contrast',
  'exposure',
  'false_color',
  'gamma',
  'grayscale',
  'hald_lookup',
  'halftone',
  'highlight_shadow',
  'lookup',
  'luminance',
  'luminance_threshold',
  'monochrome',
  'opacity',
  'posterize',
  'rgb',
  'saturation',
  'solarize',
  'vibrance',
  'vignette',
  'white_balance',
];

String get userHome =>
    Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? '~';

Future<void> main(List<String> arguments) async {
  if (arguments.firstOrNull == 'generate') {
    String glslRoot =
        '$userHome/.pub-cache/hosted/pub.dev/flutter_image_filters-0.0.30/shaders';

    String? glslCustomRoot;
    String? glslOutput;
    String? filters;
    for (int i = 0; i < arguments.length; i++) {
      final arg = arguments[i];
      if (arg == '--glsl-output') {
        glslOutput = arguments[i + 1];
      }
      if (arg == '--glsl-root') {
        glslCustomRoot = arguments[i + 1];
      }
      if (arg == '--filters') {
        filters = arguments[i + 1];
      }
    }
    final shadersFolder = Directory(glslRoot);
    if (!shadersFolder.existsSync()) {
      stderr.writeln('Specify path to shader sources');
      return;
    }
    if (filters == null) {
      stderr.writeln("Specify filters' list'");
      return;
    }
    final shaders = filters.split(',');
    if (shaders.length <= 1) {
      stderr.writeln("Specify filters' list'");
      return;
    }
    final targetFolder = Directory(glslOutput ?? 'shaders');
    if (!targetFolder.existsSync()) {
      targetFolder.createSync(recursive: true);
    }
    generateShader(shadersFolder, shaders, targetFolder, glslCustomRoot);
  }
  if (arguments.firstOrNull == 'help' || arguments.isEmpty) {
    stdout.writeln('\nAvailable subcommands:');
    stdout.writeln('\tgenerate\t\t\tGenerate new shader source');
    stdout.writeln('\thelp\t\t\t\tPrint this usage information.');

    stdout.writeln(
      '\nUsage: flutter_image_filters generate --glsl-root <path> --glsl-output <path> --filters brightness,contrast',
    );
    stdout.writeln(
      '\t--glsl-root\t\t\tFolder where to found original glsl sources',
    );
    stdout.writeln(
      '\t--glsl-output\t\t\tDestination folder for file shader source',
    );
    stdout.writeln('\t--filters\t\t\tList of filters');

    stdout.writeln('\nAvailable filters:');
    for (final name in supported) {
      stdout.writeln('\t$name');
    }
    return;
  }
}

void generateShader(
  Directory sourcesFolder,
  List<String> shaders,
  Directory targetFolder,
  String? customSourcesFolder,
) {
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
    final shaderFile = File('${sourcesFolder.absolute.path}/$shader.frag');
    if (shaderFile.existsSync()) {
      processShader(
        shaderFile,
        shaderInputs,
        shaderSamplers,
        processFunctions,
        shaderConstants,
      );
    } else if (customSourcesFolder != null) {
      processShader(
        File('${Directory(customSourcesFolder).absolute.path}/$shader.frag'),
        shaderInputs,
        shaderSamplers,
        processFunctions,
        shaderConstants,
      );
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
  final outputFile =
      File('${targetFolder.absolute.path}/${shaders.join('_')}.frag');
  outputFile.writeAsStringSync(
    finalShader.join('\n').replaceAll(RegExp('\n{3,}'), '\n\n'),
  );
}

void processShader(
  File shader,
  List<String> finalInputs,
  List<String> samplers,
  List<String> processFunctions,
  List<String> shaderConstants,
) {
  List<String> shaderLines = shader
      .readAsLinesSync()
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
