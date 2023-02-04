
![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white) ![OpenGL](https://img.shields.io/badge/OpenGL-%23FFFFFF.svg?style=for-the-badge&logo=opengl) 

<p align="center">
<a href="https://pub.dev/packages/flutter_image_filters"><img src="https://img.shields.io/pub/v/flutter_image_filters.svg" alt="Pub"></a>
<a href="https://codecov.io/gh/nikolaydymura/flutter_image_filters"><img src="https://codecov.io/gh/nikolaydymura/flutter_image_filters/main/master/graph/badge.svg" alt="codecov"></a>
<a href="https://github.com/nikolaydymura/flutter_image_filters/actions"><img src="https://github.com/nikolaydymura/flutter_image_filters/actions/workflows/flutter_image_filters.yaml/badge.svg" alt="build"></a>
<a href="https://github.com/nikolaydymura/flutter_image_filters"><img src="https://img.shields.io/github/stars/nikolaydymura/flutter_image_filters.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

A flutter package for iOS and Android for applying OpenGL filters to image.

## Usage

### Export processed image

```dart
final texture = await TextureSource.fromAsset('demo.jpeg');
final configuration = BrightnessShaderConfiguration();
configuration.brightness = 0.5;
final image = await configuration.export(texture, texture.size);
```

### Pipeline export 

In case you see performance issues, look on [how to generate and use bunch of filters](https://github.com/nikolaydymura/flutter_image_filters/blob/main/GENERATE.md)

```dart
final texture = await TextureSource.fromAsset('demo.jpeg');
final brConfig = BrightnessShaderConfiguration();
brConfig.brightness = 0.5;

final stConfig = SaturationShaderConfiguration();
stConfig.saturation = 0.5;

final configuration = GroupShaderConfiguration();
configuration.add(brConfig);
configuration.add(stConfig);
final result = await configuration.export(texture, texture.size);
```

### LookupTable sample
![LUT](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/lookup_amatorka.png)
```dart
final texture = await TextureSource.fromAsset('demo.jpeg');
final configuration = SquareLookupTableShaderConfiguration();
await configuration.setLutAsset('lookup_amatorka.png');
final image = await configuration.export(texture, texture.size);
```

### LookupTable HALD sample
![LUT](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/lookup_hald.png)
```dart
final texture = await TextureSource.fromAsset('demo.jpeg');
final configuration = HALDLookupTableShaderConfiguration();
await configuration.setLutAsset('lookup_hald.png');
final image = await configuration.export(texture, texture.size);
```

### ImageShaderPreview example
```dart
import 'package:flutter_image_filters/flutter_image_filters.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({Key? key}) : super(key: key);

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late TextureSource texture;
  late BrightnessShaderConfiguration configuration;
  bool textureLoaded = false;

  @override
  void initState() {
    super.initState();
    configuration = BrightnessShaderConfiguration();
    configuration.brightness = 0.5;
    TextureSource.fromAsset('demo.jpeg')
        .then((value) => texture = value)
        .whenComplete(
          () => setState(() {
            textureLoaded = true;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return textureLoaded
        ? ImageShaderPreview(
            texture: texture,
            configuration: configuration,
          )
        : const Offstage();
  }
}
```

### PipelineImageShaderPreview example
```dart
class PreviewPage extends StatefulWidget {
  const PreviewPage({Key? key}) : super(key: key);

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late TextureSource texture;
  late GroupShaderConfiguration configuration;
  bool textureLoaded = false;

  @override
  void initState() {
    super.initState();
    configuration = GroupShaderConfiguration();
    configuration.add(BrightnessShaderConfiguration()..brightness = 0.5);
    configuration.add(SaturationShaderConfiguration()..saturation = 0.5);
    TextureSource.fromAsset('demo.jpeg')
        .then((value) => texture = value)
        .whenComplete(
          () => setState(() {
        textureLoaded = true;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return textureLoaded
        ? PipelineImageShaderPreview(
      texture: texture,
      configuration: configuration,
    )
        : const Offstage();
  }
}
```

### Divided preview sample
```dart
import 'package:before_after_image_slider_nullsafty/before_after_image_slider_nullsafty.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({Key? key}) : super(key: key);

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late TextureSource texture;
  late BrightnessShaderConfiguration configuration;
  bool textureLoaded = false;

  @override
  void initState() {
    super.initState();
    configuration = BrightnessShaderConfiguration();
    configuration.brightness = 0.5;
    TextureSource.fromAsset('demo.jpeg')
        .then((value) => texture = value)
        .whenComplete(
          () => setState(() {
            textureLoaded = true;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return textureLoaded
        ? BeforeAfter(
            thumbRadius: 0.0,
            thumbColor: Colors.transparent,
            beforeImage: ImageShaderPreview(
              texture: texture,
              configuration: NoneShaderConfiguration(),
            ),
            afterImage: ImageShaderPreview(
              texture: texture,
              configuration: configuration,
            ),
          )
        : const Offstage();
  }
}
```

### Export & save processed image

```dart
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';



final texture = await TextureSource.fromAsset('demo.jpeg');
final configuration = BrightnessShaderConfiguration();
configuration.brightness = 0.5;
final image = await configuration.export(texture, texture.size);

final directory = await getTemporaryDirectory();
final output =
File('${directory.path}/result.jpeg');
final bytes = await image.toByteData();
final persistedImage = img.Image.fromBytes(
  image.width,
  image.height,
  bytes!.buffer.asUint8List(),
);
img.JpegEncoder encoder = img.JpegEncoder();
final data = encoder.encodeImage(persistedImage);
await output.writeAsBytes(data);
```

## Additional information

### Support status of [GPUImage for iOS](https://github.com/BradLarson/GPUImage2) and [GPUImage for Android](https://github.com/cats-oss/android-gpuimage) shaders

| Status             | Name                |
|:-------------------|:--------------------|
 | :white_check_mark: | Brightness          |
 | :white_check_mark: | Bulge Distortion    |
 | :white_check_mark: | CGA Colorspace      |
 | :white_check_mark: | Color Invert        |
 | :white_check_mark: | Color Matrix        |
 | :white_check_mark: | Contrast            |
 | :white_check_mark: | Crosshatch          |
 | :white_check_mark: | Exposure            |
 | :white_check_mark: | False Color         |
 | :white_check_mark: | Gamma               |
 | :white_check_mark: | Glass Sphere        |
 | :white_check_mark: | Grayscale           |
 | :white_check_mark: | Halftone            |
 | :white_check_mark: | Haze                |
 | :white_check_mark: | Highlight Shadow    |
 | :white_check_mark: | Hue                 |
 | :white_check_mark: | Lookup Table        |
 | :white_check_mark: | Luminance           |
 | :white_check_mark: | Luminance Threshold |
 | :white_check_mark: | Monochrome          |
 | :white_check_mark: | Opacity             |
 | :white_check_mark: | Pixelation          |
 | :white_check_mark: | Posterize           |
 | :white_check_mark: | RGB                 |
 | :white_check_mark: | Saturation          |
 | :white_check_mark: | Solarize            |
 | :white_check_mark: | Swirl               |
 | :white_check_mark: | Vibrance            |
 | :white_check_mark: | Vignette            |
 | :white_check_mark: | White Balance       |
 | :white_check_mark: | Zoom Blur           |

### Sample results

![Brightness](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Brightness.jpg)
![Bulge Distortion](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Bulge%20Distortion.jpg)
![CGA Colorspace](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/CGA%20Colorspace.jpg)
![Color Invert](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Color%20Invert.jpg)
![Color Matrix](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Color%20Matrix.jpg)
![Contrast](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Contrast.jpg)
![Crosshatch](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Crosshatch.jpg)
![Exposure](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Exposure.jpg)
![False Color](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/False%20Color.jpg)
![Gamma](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Gamma.jpg)
![Grayscale](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Grayscale.jpg)
![Halftone](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Halftone.jpg)
![Haze](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Haze.jpg)
![Highlight Shadow](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Highlight%20Shadow.jpg)
![Hue](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Hue.jpg)
![Square Lookup Table](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Square%20Lookup%20Table.jpg)
![Luminance Threshold](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Luminance%20Threshold.jpg)
![Luminance](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Luminance.jpg)
![Monochrome](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Monochrome.jpg)
![Opacity](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Opacity.jpg)
![Pixelation](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Pixelation.jpg)
![Posterize](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Posterize.jpg)
![RGB](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/RGB.jpg)
![Saturation](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Saturation.jpg)
![Solarize](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Solarize.jpg)
![Swirl](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Swirl.jpg)
![Vibrance](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Vibrance.jpg)
![Vignette](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Vignette.jpg)
![White Balance](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/White%20Balance.jpg)
![Zoom Blur](https://raw.githubusercontent.com/nikolaydymura/flutter_image_filters/main/demos/Zoom%20Blur.jpg)

## Examples

- [Big Flutter Filters Demo](https://github.com/nikolaydymura/image_filters_example) - big example of how to use filters and.

## Maintainers

- [Nikolay Dymura](https://github.com/nikolaydymura)
- [Egor Terekhov](https://github.com/EgorEko)
- [Nataliia Zabiiaka](https://github.com/nataliiazabiiaka)