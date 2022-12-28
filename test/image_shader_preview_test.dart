import 'dart:io';
import 'dart:math';

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
    testWidgets('Kuwahara always fails', (tester) async {
      final configuration = KuwaharaShaderConfiguration();
      configuration.radius = 2.0;
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
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/Kuwahara-failed.png'),
      );
    });
    testWidgets('Glass Sphere always fails', (tester) async {
      final configuration = GlassSphereShaderConfiguration();
      configuration.radius = 0.5;
      configuration.refractiveIndex = 0.71;
      configuration.center = const Point(0.7, 0.7);
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
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/GlassSphere-failed.png'),
      );
    });
    testWidgets('display error', (tester) async {
      final configuration = MonochromeShaderConfiguration();
      FlutterImageFilters.register<MonochromeShaderConfiguration>(
        () async => throw 'Oops!!!',
        override: true,
      );
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
