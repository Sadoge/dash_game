import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class GameMenu extends PositionComponent with TapCallbacks {
  final String text;
  final VoidCallback onTap;

  GameMenu({required this.text, required this.onTap})
      : super(size: Vector2(300, 100), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    final buttonBox = RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.blue.withOpacity(0.5),
      anchor: Anchor.center,
    );
    buttonBox.position = size / 2;
    add(buttonBox);

    final textComponent = TextComponent(
      text: text,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 32, color: Colors.white),
      ),
      anchor: Anchor.center,
      position: size / 2,
    );
    add(textComponent);
  }

  @override
  void onTapDown(TapDownEvent event) => onTap();
}
