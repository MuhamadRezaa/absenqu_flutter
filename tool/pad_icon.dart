import 'dart:io';
import 'package:image/image.dart' as img;

void main(List<String> args) {
  final inputPath = args.isNotEmpty
      ? args[0]
      : 'assets/images/absenqu-icon.png';
  final outputPath = args.length > 1
      ? args[1]
      : 'assets/images/absenqu-icon-foreground.png';

  final bytes = File(inputPath).readAsBytesSync();
  final original = img.decodeImage(bytes);
  if (original == null) {
    stderr.writeln('Failed to read image: $inputPath');
    exit(1);
  }

  final w = original.width;
  final h = original.height;
  final padRatio = 0.2; // 20% padding di setiap sisi
  final canvasW = w;
  final canvasH = h;
  final targetW = (w * (1 - padRatio * 2)).round();
  final targetH = (h * (1 - padRatio * 2)).round();

  final resized = img.copyResize(
    original,
    width: targetW,
    height: targetH,
    interpolation: img.Interpolation.cubic,
  );
  final canvas = img.Image(width: canvasW, height: canvasH);
  // transparan
  img.fill(canvas, img.getColor(0, 0, 0, 0));

  final dx = ((canvasW - targetW) / 2).round();
  final dy = ((canvasH - targetH) / 2).round();
  img.copyInto(canvas, resized, dstX: dx, dstY: dy);

  File(outputPath).writeAsBytesSync(img.encodePng(canvas));
  stdout.writeln('Wrote padded foreground: $outputPath');
}
