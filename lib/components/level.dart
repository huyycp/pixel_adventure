import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/data/constants/game_constants.dart';
import 'package:pixel_adventure/components/character.dart';
import 'package:pixel_adventure/utils/enum_utils.dart';

class Level extends World {
  Level({
    this.world = GameWorlds.level2,
    required this.character,
  });

  final GameWorlds world;
  final Character character;

  @override
  FutureOr<void> onLoad() async {
    final component = await TiledComponent.load(
      '${world.name}.tmx',
      Vector2.all(16)
    );

    add(component);

    final spawnPointsLayer = component.tileMap.getLayer<ObjectGroup>(GameLayers.spawnPoints.name);

    for (var point in spawnPointsLayer!.objects) {
      final object = enumFromString(GameObjects.values, point.class_, GameObjects.unknown);
      switch (object) {
        case GameObjects.character:
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