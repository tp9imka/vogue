// Renders the Vogue WOD brand assets (app icon + splash) with Flutter's
// own canvas, so no external image tooling is needed.
//
// Run once after changing the mark:
//   flutter test tool/generate_brand_assets.dart
//
// Outputs into assets/brand/. Then regenerate platform assets:
//   dart run flutter_launcher_icons
//   dart run flutter_native_splash:create
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

const ui.Color _background = ui.Color(0xFF0C0E11);
const ui.Color _bolt = ui.Color(0xFFC8FA4B);

// A lightning bolt outline, normalized. Bounding box is centered on
// (0.52, 0.50); the renderer recenters and scales it onto the canvas.
const List<List<double>> _boltPoints = [
  [0.66, 0.08],
  [0.34, 0.52],
  [0.50, 0.52],
  [0.40, 0.92],
  [0.70, 0.44],
  [0.52, 0.44],
  [0.58, 0.08],
];

const double _boltCenterX = 0.52;
const double _boltCenterY = 0.50;

ui.Path _boltPath(double size, double scale) {
  final path = ui.Path();
  for (var i = 0; i < _boltPoints.length; i++) {
    final x = (0.5 + (_boltPoints[i][0] - _boltCenterX) * scale) * size;
    final y = (0.5 + (_boltPoints[i][1] - _boltCenterY) * scale) * size;
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  path.close();
  return path;
}

Future<void> _render(
  String path,
  int size, {
  required bool withBackground,
  required double boltScale,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  final dimension = size.toDouble();

  if (withBackground) {
    canvas.drawRect(
      ui.Rect.fromLTWH(0, 0, dimension, dimension),
      ui.Paint()..color = _background,
    );
  }
  canvas.drawPath(
    _boltPath(dimension, boltScale),
    ui.Paint()
      ..color = _bolt
      ..isAntiAlias = true,
  );

  final image = await recorder.endRecording().toImage(size, size);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  final file = File(path)..parent.createSync(recursive: true);
  file.writeAsBytesSync(data!.buffer.asUint8List());
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('generate brand assets', () async {
    // Full-bleed icon for iOS and legacy Android.
    await _render(
      'assets/brand/icon.png',
      1024,
      withBackground: true,
      boltScale: 0.95,
    );
    // Transparent foreground for the Android adaptive icon (safe zone).
    await _render(
      'assets/brand/icon_foreground.png',
      1024,
      withBackground: false,
      boltScale: 0.66,
    );
    // Splash mark — transparent, centered.
    await _render(
      'assets/brand/splash.png',
      768,
      withBackground: false,
      boltScale: 0.7,
    );

    expect(File('assets/brand/icon.png').existsSync(), isTrue);
    expect(File('assets/brand/icon_foreground.png').existsSync(), isTrue);
    expect(File('assets/brand/splash.png').existsSync(), isTrue);
  });
}
