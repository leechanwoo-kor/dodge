import 'package:dodge/game_manager.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:dodge/global.dart';
import 'package:dodge/missile.dart';

class SpaceShip extends SpriteComponent with CollisionCallbacks, HasGameRef<GameManager> {

  bool isLoadedFirst = false;
  bool isTouched = false;


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
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

    if (!isLoadedFirst) {
      isLoadedFirst = true;

      position = gameSize / 2;
    }
  }

  @override
  void update(double dt) {
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
