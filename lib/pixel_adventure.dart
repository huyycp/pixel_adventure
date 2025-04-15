import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:pixel_adventure/levels/level.dart';

class PixelAdventure extends FlameGame {


  @override
  Future<void> onLoad() async {
    world = Level();
    camera = CameraComponent.withFixedResolution(
      width: 640,
      height: 360,
      world: world,
    );

    camera.viewfinder.anchor = Anchor.topLeft;

    await images.loadAllImages();

    addAll([
      world,
      camera,
    ]);

    return super.onLoad();
  } 
}