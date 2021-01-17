import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';

class ScrollingBase {
  Size screenSize;
  double speed = 400;

  ScrollingBase(this.screenSize) {
    cursorX = screenSize.width;
  }

  Sprite base1 = Sprite("base.png");
  Sprite base2 = Sprite("base.png");

  double cursorX;
  void render(Canvas canvas) {
    base1.renderPosition(
        canvas, Position(cursorX - screenSize.width, 7 * screenSize.height / 8),
        size: Position(screenSize.width, screenSize.height / 8));
    base2.renderPosition(canvas, Position(cursorX, 7 * screenSize.height / 8),
        size: Position(screenSize.width, screenSize.height / 8));
  }

  void update(double t) {
    cursorX -= t * speed;
    if (cursorX < 0) {
      cursorX = screenSize.width;
    }
  }
}
