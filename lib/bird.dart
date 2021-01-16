import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flappy_bird/constants.dart';

class Bird extends Sprite {
  Bird(String fileName) : super(fileName);
  Position currentPosition = Position(20, 20);
  double speedY = 0;
  @override
  void renderCentered(Canvas canvas, Position p,
      {Position size, Paint overridePaint}) {
    super.renderCentered(canvas, p);
  }

  void calculateCurrentPosition(double time) {
    speedY += Constant.gravityAcceleration * time;
    currentPosition += Position(0, speedY * time);
  }

  void flap() {
    speedY = -600;
  }
}
