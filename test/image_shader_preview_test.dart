import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final inputFile = File('test/demo.jpeg');

  late final TextureSource texture;
  setUpAll(() async {
    texture = await TextureSource.fromMemory(inputFile.readAsBytesSync());
  });

  group('ImageShaderPreview', () {
    testWidgets('display error', (tester) async {
      final configuration = MonochromeShaderConfiguration();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageShaderPreview.custom(
              texture: texture,
              configuration: configuration,
              fragmentProgramProvider: () async => throw 'Oops!!!',
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      final errorFinder = find.text('Oops!!!');
      expect(errorFinder, findsOneWidget);
    });

    testWidgets('successfully draw', (tester) async {
      final configuration = MonochromeShaderConfiguration();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageShaderPreview(
              texture: texture,
              configuration: configuration,
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      final canvasFinder = find.byType(CustomPaint);
      expect(canvasFinder, findsAtLeastNWidgets(1));
    });
    testWidgets('successfully redraw', (tester) async {
      final configuration = MonochromeShaderConfiguration();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageShaderPreview(
              texture: texture,
              configuration: configuration,
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      final canvasFinder = find.byType(CustomPaint);
      expect(canvasFinder, findsAtLeastNWidgets(1));
      configuration.intensity = 0.5;
      await tester.pump(const Duration(milliseconds: 100));
    });
  });
}
