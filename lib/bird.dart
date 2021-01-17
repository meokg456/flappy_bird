import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/animation.dart';
import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flappy_bird/constants.dart';
import 'dart:math' as math;

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
  SpriteComponent spriteComponent = SpriteComponent();

  Position currentPosition = Position(20, 20);
  double speedY = 0;
  double flyTime = 0;

  bool idle = true;

  void prepareRender() {
    Sprite currentSprite = animation.getSprite();
    spriteComponent.sprite = currentSprite;
    if (currentSprite.loaded()) {
      spriteComponent.width = currentSprite.src.width * 1.5;
      spriteComponent.height = currentSprite.src.height * 1.5;
    }
    spriteComponent.anchor = Anchor.center;
    double rotateRadian = (speedY) / 500;
    rotateRadian = rotateRadian > math.pi / 2
        ? math.pi / 2
        : rotateRadian < -math.pi / 4
            ? -math.pi / 4
            : rotateRadian;
    if (!idle)
      spriteComponent.angle = rotateRadian;
    else
      spriteComponent.angle = 0;
    spriteComponent.setByPosition(currentPosition);
  }

  void render(Canvas canvas) {
    prepareRender();
    canvas.save();
    spriteComponent.render(canvas);
    canvas.restore();
  }

  void update(double time) {
    if (!idle) {
      speedY += Constant.gravityAcceleration * time;
    } else {
      flyTime += time;
      double flyInterval = 0.4;
      if ((flyTime / flyInterval).round() % 2 == 0) {
        speedY = 40;
      } else {
        speedY = -40;
      }
    }
    currentPosition += Position(0, speedY * time);
    animation.update(time);
  }

  void flap() {
    speedY = -Constant.flapStrength;
  }
}
