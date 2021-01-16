import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart';

class Bird extends Sprite {
  Bird(String fileName) : super(fileName);
  Position currentPosition = Position(20, 20);
  double weight = 1;
  @override
  void renderCentered(Canvas canvas, Position p,
      {Position size, Paint overridePaint}) {
    super.renderCentered(canvas, p);
  }
}
