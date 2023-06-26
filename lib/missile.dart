import 'dart:math';
import 'package:dodge/game_manager.dart';
import 'package:flame/collisions.dart';
import 'package:dodge/global.dart';
import 'package:flame/components.dart';

class Missile extends SpriteComponent with CollisionCallbacks, HasGameRef<GameManager> {
  late ShapeHitbox hitbox;

  late Sprite fast;
  late Sprite normal;

  bool isLoadedFirst = false;
  bool isFast = false;
  Vector2 startPosition = Vector2(0, 0);
  Vector2 endPosition = Vector2(0, 0);

  final random = Random();

    Missile()
      : super(
          size: Vector2.all(4),
        );

  @override
  Future<void>? onLoad() async {
    fast = await Sprite.load('missile_fast.png');
    normal = await Sprite.load('missile_normal.png');

    reloadSprite();

    hitbox = CircleHitbox(radius: radius/2)
      ..renderShape = true;
    add(hitbox);

    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

    if (!isLoadedFirst) {
      isLoadedFirst = true;

      reloadPosition();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (Global.isPause() || Global.isOver()) return;

    if (isScreenOut(position.x, position.y)) {
      reloadSprite();
      reloadPosition();
    }

    var diff = endPosition - startPosition;
    double speed = dt * Global.gameSpeed;
    if (isFast) {
      speed *= 1.5;
    }

    var next = diff.normalized() * speed;
    position += next;
  }

  bool isScreenOut(double x, double y) {
    return x < 0 || x > Global.deviceWidth || y < 0 || y > Global.deviceHeight;
  }

  void reloadSprite() {
    int ran = random.nextInt(5);
    isFast = ran == 0;
    if (isFast) {
      sprite = fast;
    } else {
      sprite = normal;
    }
    anchor = Anchor.center;
  }

  void reloadPosition() {
    int ran = random.nextInt(4);
    double startX, startY, endX, endY;

    // 좌
    if (ran == 0) {
      startX = 0.0;
      startY = random.nextInt(Global.deviceHeight.toInt()).toDouble();
      endX = Global.deviceWidth;
      endY = random.nextInt(Global.deviceHeight.toInt()).toDouble();

      // 상
    } else if (ran == 1) {
      startX = random.nextInt(Global.deviceWidth.toInt()).toDouble();
      startY = 0.0;
      endX = random.nextInt(Global.deviceWidth.toInt()).toDouble();
      endY = Global.deviceHeight;

      // 우
    } else if (ran == 2) {
      startX = Global.deviceWidth;
      startY = random.nextInt(Global.deviceHeight.toInt()).toDouble();
      endX = 0.0;
      endY = random.nextInt(Global.deviceHeight.toInt()).toDouble();

      // 하
    } else {
      startX = random.nextInt(Global.deviceWidth.toInt()).toDouble();
      startY = Global.deviceHeight;
      endX = random.nextInt(Global.deviceWidth.toInt()).toDouble();
      endY = 0.0;
    }

    startPosition = Vector2(startX, startY);
    endPosition = Vector2(endX, endY);
    position = Vector2(startX, startY);
  }
}
