import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flappy_bird/constants.dart';
import 'package:flutter/cupertino.dart';

class ScrollingBase {
  Position cursor;
  Size size;

  ScrollingBase(Size screenSize) {
    cursor = Position(screenSize.width, 7 * screenSize.height / 8);
    size = Size(screenSize.width, screenSize.height - cursor.y);
  }

  Sprite base1 = Sprite("base.png");
  Sprite base2 = Sprite("base.png");

  void render(Canvas canvas) {
    base1.renderPosition(canvas, Position(cursor.x - size.width, cursor.y),
        size: Position(size.width, size.height));
    base2.renderPosition(canvas, Position(cursor.x, cursor.y),
        size: Position(size.width, size.height));
  }

  void update(double t) {
    cursor.x -= t * Constant.speedX;
    if (cursor.x < 0) {
      cursor.x = size.width;
    }
  }
}
