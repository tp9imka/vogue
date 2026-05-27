// Imports a 1024×1024 source PNG as the app icon.
//
// Drop the new artwork at `assets/brand/icon_source.png` and run:
//   flutter test tool/import_app_icon.dart
//
// This writes:
//   assets/brand/icon.png            — copy of the source (iOS + legacy Android)
//   assets/brand/icon_foreground.png — source scaled into the Android adaptive
//                                      safe zone on a transparent canvas
//
// Then regenerate platform icons:
//   dart run flutter_launcher_icons
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const String _source = 'assets/brand/icon_source.png';
const String _iconOut = 'assets/brand/icon.png';
const String _foregroundOut = 'assets/brand/icon_foreground.png';

/// Fraction of the canvas the artwork occupies in the adaptive-icon
/// foreground. Android guarantees that the inner ~66% of the foreground
/// is visible under every launcher mask (circle / squircle / square).
const double _safeZoneScale = 0.66;

Future<ui.Image> _loadPng(String path) async {
  final bytes = await File(path).readAsBytes();
  final codec = await ui.instantiateImageCodec(bytes);
  return (await codec.getNextFrame()).image;
}

Future<void> _writePng(ui.Image image, String path) async {
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  File(path).writeAsBytesSync(data!.buffer.asUint8List());
}

Future<ui.Image> _renderForeground(ui.Image source, int canvasSize) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  final scaled = canvasSize * _safeZoneScale;
  final offset = (canvasSize - scaled) / 2;
  canvas.drawImageRect(
    source,
    Rect.fromLTWH(0, 0, source.width.toDouble(), source.height.toDouble()),
    Rect.fromLTWH(offset, offset, scaled, scaled),
    Paint()..filterQuality = FilterQuality.high,
  );
  return recorder.endRecording().toImage(canvasSize, canvasSize);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('import app icon from source', () async {
    expect(
      File(_source).existsSync(),
      isTrue,
      reason: 'Drop the new icon at $_source first.',
    );
    final source = await _loadPng(_source);
    expect(source.width, 1024);
    expect(source.height, 1024);

    // iOS + legacy Android: full-bleed copy of the source.
    File(_source).copySync(_iconOut);

    // Android adaptive foreground: scaled into the safe zone on a
    // transparent canvas.
    final foreground = await _renderForeground(source, 1024);
    await _writePng(foreground, _foregroundOut);

    expect(File(_iconOut).existsSync(), isTrue);
    expect(File(_foregroundOut).existsSync(), isTrue);
  });
}
