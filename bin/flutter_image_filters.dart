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
  'white_balance'
];

Future<void> main(List<String> arguments) async {
  if (arguments.firstOrNull == 'generate') {
    String? glslRoot;
    String? glslOutput;
    String? filters;
    for (int i = 0; i < arguments.length; i++) {
      final arg = arguments[i];
      if (arg == '--glsl-root') {
        glslRoot = arguments[i + 1];
      }
      if (arg == '--glsl-output') {
        glslOutput = arguments[i + 1];
      }
      if (arg == '--filters') {
        filters = arguments[i + 1];
      }
    }
    if (glslRoot == null) {
      stderr.writeln('Specify path to shader sources');
      return;
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
    generateShader(shadersFolder, shaders, targetFolder);
    final result = await Process.run('flutter', [
      'pub',
      'run',
      'shader',
      '--use-remote',
      '--path',
      targetFolder.absolute.path,
      '--to-dart'
    ]);
    stdout.write(result.stdout);
    stderr.write(result.stderr);
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
) {
  List<String> finalShader = [
    '#version 320 es',
    'precision mediump float;',
    '\n',
    'layout(location = 0) out vec4 fragColor;'
  ];
  List<String> shaderInputs = [];
  List<String> processFunctions = [];
  List<String> shaderConstants = [];
  for (String shader in shaders) {
    processShader(
      File('${sourcesFolder.absolute.path}/$shader.glsl'),
      shaderInputs,
      processFunctions,
      shaderConstants,
    );
  }
  shaderInputs.add(
    'layout(location = ${shaderInputs.length}) uniform vec2 screenSize;',
  );
  shaderInputs.add(
    'layout(location = ${shaderInputs.length}) uniform sampler2D inputImageTexture;',
  );

  finalShader.addAll(shaderInputs);
  finalShader.add('\n');
  finalShader.addAll(shaderConstants);
  finalShader.add('\n');
  finalShader.addAll(processFunctions);
  finalShader.add('\n');
  finalShader.add('void main(){');
  finalShader.add('\tvec2 textureCoordinate = gl_FragCoord.xy / screenSize;');
  finalShader.add(
    '\tvec4 textureColor = texture(inputImageTexture, textureCoordinate);',
  );
  int lastIndex = 0;
  for (final func in processFunctions) {
    if (func.startsWith('vec4 processColor')) {
      final index =
          int.parse(func.replaceAll('vec4', '').replaceAll(RegExp(r'\D'), ''));
      finalShader.add(
        '\tvec4 processedColor$index = processColor$index(${index == 0 ? 'textureColor' : 'processedColor${index - 1}'});',
      );
      lastIndex = index;
    }
  }
  finalShader.add(
    '\tfragColor = processedColor$lastIndex;',
  );
  finalShader.add('}');
  final outputFile =
      File('${targetFolder.absolute.path}/${shaders.join('_')}.glsl');
  outputFile.writeAsStringSync(
    finalShader.join('\n').replaceAll(RegExp('\n{3,}'), '\n\n'),
  );
}

void processShader(
  File shader,
  List<String> finalInputs,
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
    if (element.startsWith('layout')) {
      if (element.endsWith('screenSize;') ||
          element.endsWith('inputImageTexture;') ||
          element.endsWith('fragColor;')) {
        continue;
      }
      final start = element.lastIndexOf('uniform') + 8;
      finalInputs.add(
        'layout(location = ${finalInputs.length}) uniform ${element.substring(
          start,
        )}',
      );
      continue;
    }

    if (element.startsWith('vec4 processColor')) {
      final index = processFunctions
          .where((element) => element.startsWith('vec4 processColor'))
          .length;
      processFunctions.add('vec4 processColor$index(vec4 sourceColor){');
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
