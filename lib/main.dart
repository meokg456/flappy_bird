import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flappy_bird/flappy_bird_game.dart';
import 'package:flutter/material.dart';

void main() {
  FlappyBirdGame game = FlappyBirdGame();
  runApp(game.widget);
  Flame.util.setPortraitUpOnly();
}
