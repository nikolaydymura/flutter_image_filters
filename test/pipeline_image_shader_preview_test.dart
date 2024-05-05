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

  group('PipelineImageShaderPreview', () {
    testWidgets('Kuwahara always fails', (tester) async {
      final configuration = GroupShaderConfiguration()
        ..add(KuwaharaShaderConfiguration()..radius = 2.0);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PipelineImageShaderPreview(
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
      final configuration = GroupShaderConfiguration()
        ..add(
          GlassSphereShaderConfiguration()
            ..radius = 0.5
            ..refractiveIndex = 0.71
            ..center = const Point(0.7, 0.7),
        );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PipelineImageShaderPreview(
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
      final configuration = GroupShaderConfiguration()
        ..add(InvalidConfiguration());
      FlutterImageFilters.register<InvalidConfiguration>(
        () async => throw 'Oops!!!',
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PipelineImageShaderPreview(
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
    testWidgets('remove single item from group', (tester) async {
      final monochromeShaderConfiguration = MonochromeShaderConfiguration();
      final configuration = GroupShaderConfiguration()
        ..add(monochromeShaderConfiguration);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PipelineImageShaderPreviewDemo(
              texture: texture,
              configuration: configuration,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      configuration.remove(monochromeShaderConfiguration);
      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      final errorFinder = find.textContaining('Group is empty');
      expect(errorFinder, findsOneWidget);
    });

    testWidgets('clear group', (tester) async {
      final configuration = GroupShaderConfiguration()
        ..add(MonochromeShaderConfiguration());
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PipelineImageShaderPreviewDemo(
              texture: texture,
              configuration: configuration,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      configuration.clear();
      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      final errorFinder = find.textContaining('Group is empty');
      expect(errorFinder, findsOneWidget);
    });

    testWidgets('successfully draw', (tester) async {
      final configuration = GroupShaderConfiguration()
        ..add(MonochromeShaderConfiguration());
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PipelineImageShaderPreviewDemo(
              texture: texture,
              configuration: configuration,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      final canvasFinder = find.byType(CustomPaint);
      expect(canvasFinder, findsAtLeastNWidgets(1));
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
    testWidgets('successfully re-draw', (tester) async {
      final monoConfiguration = MonochromeShaderConfiguration();

      final configuration = GroupShaderConfiguration()..add(monoConfiguration);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PipelineImageShaderPreviewDemo(
              texture: texture,
              configuration: configuration,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      final canvasFinder = find.byType(CustomPaint);
      expect(canvasFinder, findsAtLeastNWidgets(1));
      expect(find.byType(CircularProgressIndicator), findsNothing);
      monoConfiguration.intensity = 0.5;
      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      expect(canvasFinder, findsAtLeastNWidgets(1));
      await tester.pump(const Duration(milliseconds: 100));
    });
  });
}

class PipelineImageShaderPreviewDemo extends StatefulWidget {
  final TextureSource texture;
  final GroupShaderConfiguration configuration;

  const PipelineImageShaderPreviewDemo({
    super.key,
    required this.texture,
    required this.configuration,
  });

  @override
  State<PipelineImageShaderPreviewDemo> createState() =>
      _PipelineImageShaderPreviewDemoState();
}

class _PipelineImageShaderPreviewDemoState
    extends State<PipelineImageShaderPreviewDemo> {
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
          child: PipelineImageShaderPreview(
            texture: widget.texture,
            configuration: widget.configuration,
          ),
        ),
      ],
    );
  }
}
