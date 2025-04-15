import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/data/constants/game_constants.dart';
import 'package:pixel_adventure/character.dart';

class Level extends World {

  late TiledComponent component;

  @override
  FutureOr<void> onLoad() async {
    component = await TiledComponent.load(
      'level_1.tmx',
      Vector2.all(16)
    );

    add(component);

    final spawnPointsLayer = component.tileMap.getLayer<ObjectGroup>(GameLayers.spawnPoints);

    for (var point in spawnPointsLayer!.objects) {
      switch (point.class_) {
        case GameObjects.character:
          final character = Character(GameCharacters.virtualGuy);
          character.position = point.position;
          add(character);
          break;
        default:
          break;
      }
    }

    return super.onLoad();
  }
}