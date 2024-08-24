import 'package:dash_game/src/geometry_dash_clone.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

void main() {
  runApp(
    GameWidget(
      game: GeometryDashClone(),
    ),
  );
}
