import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flappy_bird/constants.dart';
import 'package:flappy_bird/couple_pipe.dart';
import 'package:flappy_bird/scrolling_base.dart';

enum GameStatus { guide, playing, gameOver }

class FlappyBirdGame extends BaseGame with TapDetector {
  Size screenSize;
  Bird bird = Bird();
  List<CouplePipe> pipes = [];
  double respawnTime = 0;
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
    canvas.save();
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

    for (var pipe in pipes) {
      pipe.render(canvas);
    }
    bird.render(canvas);
    if (gameStatus == GameStatus.gameOver) {
      gameOverSprite.renderCentered(
          canvas, Position(screenSize.width / 2, screenSize.height / 2));
    }
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
    //respawn pipes
    respawnTime += t;
    if (respawnTime > Constant.spawnInterval) {
      respawnTime = 0;
      pipes.add(CouplePipe(Position(screenSize.width, base.cursor.y)));
    }
    if (gameStatus != GameStatus.gameOver) {
      //update base
      if (base != null) {
        base.update(t);
      }
      //update pipes
      for (var pipe in pipes) {
        pipe.update(t);
      }
      //remove pipes out of screen
      pipes.removeWhere((element) => element.pipe.loaded()
          ? element.position.x < 0 - element.pipe.src.width
          : false);
      //update bird
      if (base != null) if (detectCollision()) {
        gameStatus = GameStatus.gameOver;
      }
    }
    if (base != null) if (bird.currentPosition.y < base.cursor.y)
      bird.update(t);
  }

  bool detectCollision() {
    SpriteComponent spriteComponent = bird.spriteComponent;
    Rect birdBox = Rect.fromCenter(
        center: Offset(spriteComponent.x, spriteComponent.y),
        width: spriteComponent.width,
        height: spriteComponent.width);
    Rect baseBox =
        Rect.fromLTWH(0, base.cursor.y, base.size.width, base.size.height);
    Rect skyBox = Rect.fromLTWH(0, 0, screenSize.width, 1);
    if (birdBox.overlaps(baseBox) || birdBox.overlaps(skyBox)) {
      return true;
    }
    for (var pipe in pipes) {
      Rect pipeBox = Rect.fromLTWH(
          pipe.spriteComponent.x,
          pipe.spriteComponent.y,
          pipe.spriteComponent.width,
          pipe.spriteComponent.height);
      if (birdBox.overlaps(pipeBox)) {
        gameStatus = GameStatus.gameOver;
        return true;
      }
    }
    return false;
  }

  @override
  void resize(Size size) {
    screenSize = size;
    base = ScrollingBase(size);
    bird.currentPosition = Position(size.width / 4, size.height / 2);
    super.resize(size);
  }
}
