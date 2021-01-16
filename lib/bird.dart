import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flappy_bird/constants.dart';

class Bird {
  List<Sprite> sprites = [
    Sprite("redbird-downflap.png"),
    Sprite("redbird-midflap.png"),
    Sprite("redbird-upflap.png")
  ];
  Bird() {
    animation = Animation.spriteList(sprites, stepTime: 0.1, loop: true);
  }
  Animation animation;
  Position currentPosition = Position(20, 20);
  double speedY = 0;

  void calculateCurrentPosition(double time) {
    speedY += Constant.gravityAcceleration * time;
    currentPosition += Position(0, speedY * time);
  }

  void flap() {
    speedY = -600;
  }
}
