import 'package:dash_game/src/geometry_dash_clone.dart';
import 'package:dash_game/src/obstacle.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/palette.dart';

class Player extends PositionComponent
    with HasGameRef<GeometryDashClone>, CollisionCallbacks {
  static const double speed = 200;
  static const double gravity = 1500;
  static const double jumpForce = -700;
  static const double maxJumpHeight = 180;

  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool isAlive = true;
  @override
  bool isColliding = false;
  bool isMoving = false;
  double initialJumpY = 0;
  late Vector2 initialPosition;

  Player() : super(size: Vector2(50, 50)) {
    initialPosition = Vector2(50, 0);
  }

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
    add(RectangleComponent(
      size: size,
      paint: BasicPalette.red.paint(),
    ));
  }

  @override
  void update(double dt) {
    if (!isAlive || !isMoving) return;

    position.x += speed * dt;
    velocity.y += gravity * dt;
    velocity.y = velocity.y.clamp(-800, 800);
    position += velocity * dt;

    if (position.y > gameRef.size.y - size.y - 50) {
      position.y = gameRef.size.y - size.y - 50;
      velocity.y = 0;
      isOnGround = true;
    }

    if (!isOnGround && position.y < initialJumpY - maxJumpHeight) {
      position.y = initialJumpY - maxJumpHeight;
      velocity.y = 0;
    }
  }

  void jump() {
    if (isOnGround && isAlive && isMoving) {
      velocity.y = jumpForce;
      isOnGround = false;
      initialJumpY = position.y;
    }
  }

  void reset() {
    position = Vector2(initialPosition.x, gameRef.size.y - size.y - 50);
    velocity = Vector2.zero();
    isAlive = true;
    isColliding = false;
    isOnGround = true;
    isMoving = false;
  }

  void startMoving() {
    isMoving = true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Obstacle) {
      isColliding = true;
      isAlive = false; // Player dies on collision
      isMoving = false; // Stop moving on collision
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is Obstacle) {
      isColliding = false;
    }
  }
}
