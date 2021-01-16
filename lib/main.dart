import 'package:flame/flame.dart';
import 'package:flappy_bird/flappy_bird_game.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.util.fullScreen();
  Flame.util.setPortraitUpOnly();
  FlappyBirdGame game = FlappyBirdGame();
  runApp(game.widget);
}
