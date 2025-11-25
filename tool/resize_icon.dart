import 'dart:io';
import 'package:image/image.dart' as img;

void main(List<String> args) {
  final srcPath = args.isNotEmpty ? args[0] : 'assets/images/absenqu-icon.png';
  final dstPath = args.length > 1
      ? args[1]
      : 'assets/images/absenqu-icon_padded.png';
  final shrinkPercent = args.length > 2
      ? double.tryParse(args[2]!) ?? 0.8
      : 0.8;

  if (!File(srcPath).existsSync()) {
    stderr.writeln('Source image not found: ' + srcPath);
    exit(1);
  }

  final bytes = File(srcPath).readAsBytesSync();
  final src = img.decodeImage(bytes);
  if (src == null) {
    stderr.writeln('Failed to decode PNG: ' + srcPath);
    exit(1);
  }

  final maxSide = src.width > src.height ? src.width : src.height;
  final canvasSize = maxSide;
  final targetSize = (canvasSize * shrinkPercent).round();

  final resized = img.copyResize(src, width: targetSize);
  final canvas = img.Image(width: canvasSize, height: canvasSize);
  img.fill(canvas, color: img.ColorRgba8(255, 255, 255, 255));

  final dx = ((canvasSize - resized.width) / 2).round();
  final dy = ((canvasSize - resized.height) / 2).round();
  img.compositeImage(canvas, resized, dstX: dx, dstY: dy);

  final outBytes = img.encodePng(canvas);
  File(dstPath)
    ..createSync(recursive: true)
    ..writeAsBytesSync(outBytes);

  stdout.writeln('Generated padded icon -> ' + dstPath);
  stdout.writeln(
    'Canvas: ' + canvas.width.toString() + 'x' + canvas.height.toString(),
  );
  stdout.writeln(
    'Inner icon: ' + resized.width.toString() + 'x' + resized.height.toString(),
  );
}
