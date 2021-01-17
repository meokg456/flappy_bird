import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/images.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flappy_bird/scrolling_base.dart';

enum GameStatus { guide, playing, gameOver }

class FlappyBirdGame extends BaseGame with TapDetector {
  Size screenSize;
  Bird bird = Bird();
  GameStatus gameStatus = GameStatus.guide;
  Sprite gameOverSprite = Sprite("gameover.png");
  Sprite background = Sprite(
      DateTime.now().hour >= 6 && DateTime.now().hour <= 18
          ? "background-day.png"
          : "background-night.png");
  Sprite guide = Sprite("message.png");
  ScrollingBase base;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    background.render(canvas,
        height: screenSize.height, width: screenSize.width);
    base.render(canvas);
    if (gameStatus == GameStatus.guide) {
      if (guide.loaded())
        guide.renderCentered(
            canvas,
            Position(screenSize.width / 2,
                screenSize.height / 2 - guide.src.height / 4));
    }
    if (gameStatus == GameStatus.gameOver) {
      gameOverSprite.renderCentered(
          canvas, Position(screenSize.width / 2, screenSize.height / 2));
    }
    bird.render(canvas);
  }

  @override
  void onTap() {
    if (gameStatus == GameStatus.guide) {
      gameStatus = GameStatus.playing;
      bird.idle = false;
    }
    if (gameStatus == GameStatus.playing) {
      bird.flap();
    }
  }

  @override
  void update(double t) {
    super.update(t);
    if (gameStatus != GameStatus.gameOver) {
      if (base != null) {
        base.update(t);
      }
      bird.update(t);
      bird.animation.update(t);
      if (bird.isDead(size)) gameStatus = GameStatus.gameOver;
    }
  }

  @override
  void resize(Size size) {
    screenSize = size;
    base = ScrollingBase(size);
    bird.currentPosition = Position(size.width / 4, size.height / 2);
    super.resize(size);
  }
}
