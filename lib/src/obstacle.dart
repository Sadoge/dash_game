import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/palette.dart';

class Obstacle extends PositionComponent with CollisionCallbacks {
  Obstacle({required Vector2 size, required Vector2 position})
      : super(size: size, position: position);

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
    add(RectangleComponent(
      size: size,
      paint: BasicPalette.blue.paint(),
    ));
  }
}
