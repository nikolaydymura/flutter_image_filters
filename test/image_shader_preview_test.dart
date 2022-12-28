import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

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
      final configuration = InvalidConfiguration();
      FlutterImageFilters.register<InvalidConfiguration>(
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
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
    testWidgets('successfully re-draw', (tester) async {
      final configuration = MonochromeShaderConfiguration();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageShaderPreviewDemo(
              texture: texture,
              configuration: configuration,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      final canvasFinder = find.byType(CustomPaint);
      expect(canvasFinder, findsAtLeastNWidgets(1));
      expect(find.byType(CircularProgressIndicator), findsNothing);
      configuration.intensity = 0.5;
      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      expect(canvasFinder, findsAtLeastNWidgets(1));
      await tester.pump(const Duration(milliseconds: 100));
    });
  });
}

class ImageShaderPreviewDemo extends StatefulWidget {
  final TextureSource texture;
  final ShaderConfiguration configuration;

  const ImageShaderPreviewDemo({
    Key? key,
    required this.texture,
    required this.configuration,
  }) : super(key: key);

  @override
  State<ImageShaderPreviewDemo> createState() => _ImageShaderPreviewDemoState();
}

class _ImageShaderPreviewDemoState extends State<ImageShaderPreviewDemo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            setState(() {});
          },
          child: const Text('Update'),
        ),
        Expanded(
          child: ImageShaderPreview(
            texture: widget.texture,
            configuration: widget.configuration,
          ),
        ),
      ],
    );
  }
}
