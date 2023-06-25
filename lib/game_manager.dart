import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:dodge/global.dart';
import 'package:dodge/menu_overlay.dart';
import 'package:dodge/missile.dart';
import 'package:dodge/spaceship.dart';

class GameManager extends FlameGame with HasCollisionDetection, MouseMovementDetector {
  late SpaceShip spaceShip;
  late MenuOverlay menu;
  final List<Missile> missiles = [];

  int createCount = 50;

  @override
  Future<void>? onLoad() async {
    await images.loadAll([
      'ship.png',
      'missile_fast.png',
      'missile_normal.png',
    ]);

    Global.deviceWidth = size[0];
    Global.deviceHeight = size[1];

    spaceShip = SpaceShip();
    add(spaceShip);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (Global.isPause()) return;
    if (Global.isOver()) {
      menu.refreshScreen();
      return;
    }

    if (createCount > 0) {
      var missile = Missile();
      add(missile);
      missiles.add(missile);
      createCount--;
    }

    Global.score += dt;

    if (Global.score >= Global.level * 10 && Global.level <= 20) {
      Global.level++;
      Global.gameSpeed += 10;
      createCount += 5;
    }
    menu.refreshScreen();
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    if (Global.isPause() || Global.isOver()) return;

    spaceShip.move(info.eventPosition.game);
  }

  void restart() {
    for (var missile in missiles) {
      remove(missile);
    }
    missiles.clear();
    createCount = 50;
    spaceShip.restart();
    Global.level = 1;
    Global.gameSpeed = 100;
    Global.score = 0;
    Global.status = GameStatus.run;
  }
}