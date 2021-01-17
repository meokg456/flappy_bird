import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flappy_bird/constants.dart';
import 'package:flutter/cupertino.dart';

class CouplePipe {
  Sprite pipe = Sprite("pipe-green.png");
  Position position;
  Size size;
  double holeHeight;
  SpriteComponent spriteComponentOnBottom = SpriteComponent();
  SpriteComponent spriteComponentOnTop = SpriteComponent();
  CouplePipe(this.position, this.size, this.holeHeight);

  void render(Canvas canvas) {
    if (pipe.loaded()) {
      canvas.save();
      spriteComponentOnBottom.sprite = pipe;
      spriteComponentOnBottom.height = size.height;
      spriteComponentOnBottom.width = size.width;
      spriteComponentOnBottom.y = position.y;
      spriteComponentOnBottom.x = position.x;
      spriteComponentOnBottom.renderFlipY = false;
      spriteComponentOnBottom.anchor = Anchor.topLeft;
      spriteComponentOnBottom.render(canvas);
      canvas.restore();
      canvas.save();
      spriteComponentOnTop.sprite = pipe;
      spriteComponentOnTop.height = position.y - holeHeight;
      spriteComponentOnTop.width = size.width;
      spriteComponentOnTop.y = 0;
      spriteComponentOnTop.x = position.x;
      spriteComponentOnTop.anchor = Anchor.topLeft;
      spriteComponentOnTop.renderFlipY = true;
      spriteComponentOnTop.render(canvas);
      canvas.restore();
    }
  }

  void update(double t) {
    position.x -= t * Constant.speedX;
  }
}
