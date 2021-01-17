import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flappy_bird/constants.dart';
import 'package:flutter/cupertino.dart';

class CouplePipe {
  Sprite pipe = Sprite("pipe-green.png");
  Position position;
  SpriteComponent spriteComponent = SpriteComponent();
  CouplePipe(this.position);

  void render(Canvas canvas) {
    if (pipe.loaded()) {
      canvas.save();
      spriteComponent.sprite = pipe;
      spriteComponent.height = pipe.src.height;
      spriteComponent.width = pipe.src.width;
      spriteComponent.y = position.y - pipe.src.height;
      spriteComponent.x = position.x;
      spriteComponent.anchor = Anchor.topLeft;
      spriteComponent.render(canvas);
      canvas.restore();
    }
  }

  void update(double t) {
    position.x -= t * Constant.speedX;
  }
}
