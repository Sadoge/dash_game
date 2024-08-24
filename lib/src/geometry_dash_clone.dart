import 'dart:math';
import 'package:dash_game/src/obstacle.dart';
import 'package:dash_game/src/player.dart';
import 'package:dash_game/src/game_menu.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';

enum GameState { initial, playing, gameOver }

class GeometryDashClone extends FlameGame
    with TapDetector, HasCollisionDetection {
  late Player player;
  final Random random = Random();
  double lastObstaclePosition = 0;
  final double obstacleSpacing = 300;
  final double maxObstacleHeight = 80;
  GameState gameState = GameState.initial;
  GameMenu? currentMenu;

  final double obstacleRemovalDelay = 800;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera = CameraComponent.withFixedResolution(width: 1000, height: 600);
    world = World();
    addAll([camera, world]);

    world.add(
      RectangleComponent(
        size: Vector2(10000, 600),
        position: Vector2(-1000, 0),
        paint: BasicPalette.white.paint(),
      ),
    );

    player = Player();
    world.add(player);
    player.position = Vector2(-200, size.y - player.size.y - 50);

    camera.follow(player);

    showStartMenu();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameState != GameState.playing) return;

    // Generate new obstacles as needed
    while (player.position.x + size.x > lastObstaclePosition) {
      generateObstacle();
    }

    removeOffscreenObstacles();

    if (player.isColliding) {
      gameOver();
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (gameState == GameState.playing) {
      player.jump();
    }
  }

  void startGame() {
    gameState = GameState.playing;
    player.reset();

    world.removeAll(world.children.whereType<Obstacle>());
    lastObstaclePosition = player.position.x + size.x;
    generateInitialObstacles();
    player.startMoving();

    if (currentMenu != null) {
      remove(currentMenu!);
      currentMenu = null;
    }
  }

  void gameOver() {
    gameState = GameState.gameOver;
    player.isMoving = false;
    showGameOverMenu();
  }

  void showStartMenu() {
    currentMenu = GameMenu(
      text: 'Start Game',
      onTap: startGame,
    );
    add(currentMenu!);
    positionMenu(currentMenu!);
  }

  void showGameOverMenu() {
    currentMenu = GameMenu(
      text: 'Game Over\nTap to Restart',
      onTap: startGame,
    );
    add(currentMenu!);
    positionMenu(currentMenu!);
  }

  void positionMenu(GameMenu menu) {
    // Use camera's viewfinder to accurately place the menu at the center
    menu.position =
        Vector2(camera.viewport.size.x / 2, camera.viewport.size.y / 2);
    menu.priority = -1; // Set the priority to render the menu on top
  }

  void generateInitialObstacles() {
    double startX = player.position.x + size.x;
    for (int i = 0; i < 5; i++) {
      generateObstacle(startX: startX + i * obstacleSpacing);
    }
  }

  void generateObstacle({double? startX}) {
    const obstacleWidth = 50.0;
    final obstacleHeight = random.nextDouble() * maxObstacleHeight + 20;
    final obstacleX = startX ?? lastObstaclePosition + obstacleSpacing;
    final obstacleY = size.y - obstacleHeight - 50;

    final obstacle = Obstacle(
      size: Vector2(obstacleWidth, obstacleHeight),
      position: Vector2(obstacleX, obstacleY),
    );
    world.add(obstacle);

    lastObstaclePosition = obstacleX;
  }

  void removeOffscreenObstacles() {
    world.children.whereType<Obstacle>().forEach((obstacle) {
      if (obstacle.position.x <
          camera.viewfinder.position.x - obstacleRemovalDelay) {
        obstacle.removeFromParent();
      }
    });
  }
}
