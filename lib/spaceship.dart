import 'package:dodge/game_manager.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:dodge/global.dart';
import 'package:dodge/missile.dart';

class SpaceShip extends SpriteComponent with CollisionCallbacks, KeyboardHandler, HasGameRef<GameManager> {

  bool isLoadedFirst = false;
  bool isTouched = false;
  
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 100;

  int horizontalDirection = 0;
  int verticalDirection = 0;

  SpaceShip()
    : super(
        size: Vector2.all(32),
        anchor: Anchor.center,
      );

  @override
  Future<void>? onLoad() async {
    final starImage = game.images.fromCache('ship.png');
    sprite = Sprite(starImage);

    add(RectangleHitbox(collisionType: CollisionType.passive));

    return super.onLoad();
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyA) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? -1
        : 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;
    
    verticalDirection = 0;
    verticalDirection += (keysPressed.contains(LogicalKeyboardKey.keyW) ||
            keysPressed.contains(LogicalKeyboardKey.arrowUp))
        ? -1
        : 0;
    verticalDirection += (keysPressed.contains(LogicalKeyboardKey.keyS) ||
            keysPressed.contains(LogicalKeyboardKey.arrowDown))
        ? 1
        : 0;

    return true;
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

    if (!isLoadedFirst) {
      isLoadedFirst = true;

      position = gameSize / 2;
    }
  }

  @override
  void update(double dt) {
    velocity.x = horizontalDirection * moveSpeed;
    position.x += velocity.x * dt;
    velocity.y = verticalDirection * moveSpeed;
    position.y += velocity.y * dt;
    
    super.update(dt);

    if (Global.isPause() || Global.isOver()) return;
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    if (other is Missile) {
      super.onCollisionStart(points, other);
      Global.status = GameStatus.gameover;
    }
  }

  void move(Vector2 movePosition) {
    if (!isTouched) {
      isTouched = toRect().contains(movePosition.toOffset());
      return;
    }

    position = movePosition;
  }

  void restart() {
    isTouched = false;
    position.x = Global.deviceWidth / 2;
    position.y = Global.deviceHeight / 2;
  }
}
