library image_filters;

import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

import 'src/shaders/monochrome_sprv.dart';

part 'src/configurations/configuration.dart';
part 'src/configurations/monochrome.dart';
part 'src/widgets/image_shader_painter.dart';
part 'src/widgets/image_shader_preview.dart';
part 'src/texture_source.dart';
part 'src/shaders.dart';
