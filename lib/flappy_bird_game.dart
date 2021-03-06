import 'dart:math';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text_config.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flappy_bird/constants.dart';
import 'package:flappy_bird/couple_pipe.dart';
import 'package:flappy_bird/scrolling_base.dart';
import 'package:flutter/cupertino.dart';

enum GameStatus { guide, playing, gameOver }

class FlappyBirdGame extends BaseGame with TapDetector {
  Size screenSize;
  Bird bird = Bird();
  List<CouplePipe> pipes = [];
  double respawnTime = 0;
  TextConfig config = TextConfig(fontSize: 48.0, fontFamily: 'biome');
  GameStatus gameStatus = GameStatus.guide;
  Sprite gameOverSprite = Sprite("gameover.png");
  Sprite background = Sprite(
      DateTime.now().hour >= 6 && DateTime.now().hour <= 18
          ? "background-day.png"
          : "background-night.png");
  Sprite guide = Sprite("message.png");
  ScrollingBase base;
  Set<CouplePipe> earnedPipes = {};

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
    if (gameStatus == GameStatus.playing) {
      config.render(
          canvas, "${earnedPipes.length}", Position(size.width / 2, 50));
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
    if (gameStatus == GameStatus.gameOver) {
      bird.currentPosition = Position(size.width / 4, size.height / 2);
      pipes.removeWhere((element) => true);
      bird.idle = true;
      earnedPipes.removeWhere((element) => true);
      gameStatus = GameStatus.guide;
    }
    if (gameStatus == GameStatus.playing) {
      Flame.audio.play("wing.wav");
      bird.flap();
    }
  }

  void spawnPipe() {
    if (gameStatus == GameStatus.playing) {
      respawnTime = 0;
      double holeHeight = screenSize.height / 4;
      double bottomHeight = Random().nextDouble() * (base.cursor.y * 1 / 3) +
          base.cursor.y * 1 / 4;
      Position bottomPipePosition =
          Position(screenSize.width, base.cursor.y - bottomHeight);
      pipes.add(CouplePipe(bottomPipePosition,
          Size(screenSize.width / 4.5, bottomHeight), holeHeight));
    }
  }

  @override
  void update(double t) {
    super.update(t);
    //respawn pipes
    respawnTime += t;
    if (respawnTime > Constant.spawnInterval) {
      spawnPipe();
    }
    if (gameStatus == GameStatus.guide) {}
    if (gameStatus == GameStatus.playing) {
      //update base
      if (base != null) {
        base.update(t);
      }
      //update pipes
      for (var pipe in pipes) {
        pipe.update(t);
        if (pipe.position.x < bird.currentPosition.x) {
          if (earnedPipes.add(pipe)) {
            Flame.audio.play("point.wav");
          }
        }
      }
      //remove pipes out of screen
      pipes.removeWhere((element) => element.pipe.loaded()
          ? element.position.x < 0 - element.size.width
          : false);
      // check collision
      if (base != null) if (detectCollision()) {
        Flame.audio.play("hit.wav");
        gameStatus = GameStatus.gameOver;
        bird.speedY = 0;
      }
    }
    //update bird
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
      Rect pipeBoxOnBottom = Rect.fromLTWH(
          pipe.spriteComponentOnBottom.x,
          pipe.spriteComponentOnBottom.y,
          pipe.spriteComponentOnBottom.width,
          pipe.spriteComponentOnBottom.height);
      Rect pipeBoxOnTop = Rect.fromLTWH(
          pipe.spriteComponentOnTop.x,
          pipe.spriteComponentOnTop.y,
          pipe.spriteComponentOnTop.width,
          pipe.spriteComponentOnTop.height);
      if (birdBox.overlaps(pipeBoxOnTop) || birdBox.overlaps(pipeBoxOnBottom)) {
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
