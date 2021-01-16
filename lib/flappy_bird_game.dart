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
  double time = 0;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    bird.render(canvas);
  }

  @override
  void onTap() {
    bird.flap();
  }

  @override
  void update(double t) {
    super.update(t);
    time += t;
    bird.calculateCurrentPosition(t);
    bird.animation.update(t);
  }

  @override
  void resize(Size size) {
    screenSize = size;
    bird.currentPosition = Position(size.width / 2, size.height / 2);
    super.resize(size);
  }
}
