import 'dart:ui';

import 'dart:async';

import 'flame.dart';
import 'palette.dart';
import 'extensions/vector2.dart';

class Sprite {
  Paint paint = BasicPalette.white.paint;
  Image image;
  Rect src;

  Sprite(
    String fileName, {
    Vector2 position,
    Vector2 size,
  }) {
    position ??= Vector2.zero();
    Flame.images.load(fileName).then((img) {
      size ??= Vector2(img.width.toDouble(), img.height.toDouble());
      image = img;
      src = position.toPositionedRect(size);
    });
  }

  Sprite.fromImage(
    this.image, {
    double x = 0.0,
    double y = 0.0,
    double width,
    double height,
  }) {
    width ??= image.width.toDouble();
    height ??= image.height.toDouble();
    src = Rect.fromLTWH(x, y, width, height);
  }

  static Future<Sprite> loadSprite(
    String fileName, {
    double x = 0.0,
    double y = 0.0,
    double width,
    double height,
  }) async {
    final Image image = await Flame.images.load(fileName);
    return Sprite.fromImage(
      image,
      x: x,
      y: y,
      width: width,
      height: height,
    );
  }

  bool loaded() {
    return image != null && src != null;
  }

  double get _imageWidth => image.width.toDouble();

  double get _imageHeight => image.height.toDouble();

  Vector2 get originalSize {
    if (!loaded()) {
      return null;
    }
    return Vector2(_imageWidth, _imageHeight);
  }

  Vector2 get size {
    return Vector2(src.width, src.height);
  }

  /// Renders this Sprite on the position [p], scaled by the [scale] factor provided.
  ///
  /// It renders with src size multiplied by [scale] in both directions.
  /// Anchor is on top left as default.
  /// If not loaded, does nothing.
  void renderScaled(
    Canvas canvas,
    Vector2 p, {
    double scale = 1.0,
    Paint overridePaint,
  }) {
    if (!loaded()) {
      return;
    }
    renderPosition(canvas, p, size: size * scale, overridePaint: overridePaint);
  }

  void renderPosition(
    Canvas canvas,
    Vector2 p, {
    Vector2 size,
    Paint overridePaint,
  }) {
    if (!loaded()) {
      return;
    }
    size ??= this.size;
    renderRect(canvas, p.toPositionedRect(size), overridePaint: overridePaint);
  }

  void render(
    Canvas canvas, {
    double width,
    double height,
    Paint overridePaint,
  }) {
    if (!loaded()) {
      return;
    }
    width ??= size.x;
    height ??= size.y;
    renderRect(canvas, Rect.fromLTWH(0.0, 0.0, width, height),
        overridePaint: overridePaint);
  }

  /// Renders this sprite centered in the position [p], i.e., on [p] - [size] / 2.
  ///
  /// If [size] is not provided, the original size of the src image is used.
  /// If the asset is not yet loaded, it does nothing.
  void renderCentered(
    Canvas canvas,
    Vector2 p, {
    Vector2 size,
    Paint overridePaint,
  }) {
    if (!loaded()) {
      return;
    }
    size ??= this.size;
    renderRect(canvas,
        Rect.fromLTWH(p.x - size.x / 2, p.y - size.y / 2, size.x, size.y),
        overridePaint: overridePaint);
  }

  void renderRect(
    Canvas canvas,
    Rect dst, {
    Paint overridePaint,
  }) {
    if (!loaded()) {
      return;
    }
    canvas.drawImageRect(image, src, dst, overridePaint ?? paint);
  }
}
