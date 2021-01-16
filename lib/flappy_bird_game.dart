import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flappy_bird/bird.dart';

class FlappyBirdGame extends BaseGame with TapDetector {
  Size screenSize;
  Bird bird = Bird();
  bool gameOver = false;
  Sprite gameOverSprite = Sprite("gameover.png");

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (gameOver) {
      gameOverSprite.renderCentered(
          canvas, Position(screenSize.width / 2, screenSize.height / 2));
    }
    bird.render(canvas);
  }

  @override
  void onTap() {
    if (!gameOver) {
      bird.flap();
    }
  }

  @override
  void update(double t) {
    super.update(t);
    if (!gameOver) {
      bird.calculateCurrentPosition(t);
      bird.animation.update(t);
      gameOver = bird.isDead(size);
    }
  }

  @override
  void resize(Size size) {
    screenSize = size;
    bird.currentPosition = Position(size.width / 2, size.height / 2);
    super.resize(size);
  }
}
