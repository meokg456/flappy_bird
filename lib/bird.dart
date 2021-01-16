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

  void prepareRender() {
    Sprite currentSprite = animation.getSprite();

    spriteComponent.sprite = currentSprite;
    if (currentSprite.src != null) {
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
    spriteComponent.angle = rotateRadian;
    spriteComponent.setByPosition(currentPosition);
  }

  void render(Canvas canvas) {
    prepareRender();
    spriteComponent.render(canvas);
  }

  void calculateCurrentPosition(double time) {
    speedY += Constant.gravityAcceleration * time;
    currentPosition += Position(0, speedY * time);
  }

  void flap() {
    speedY = -600;
  }

  bool isDead(Size screenSize) {
    if (animation.getSprite().src == null) return false;
    return screenSize.height <=
        currentPosition.y + animation.getSprite().src.height;
  }
}
