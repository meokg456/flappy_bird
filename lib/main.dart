import 'package:flame/flame.dart';
import 'package:flame/images.dart';
import 'package:flappy_bird/flappy_bird_game.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.util.fullScreen();
  Flame.util.setPortraitUpOnly();
  FlappyBirdGame game = FlappyBirdGame();
  await Flame.images.load("pipe-green.png");
  runApp(game.widget);
}
