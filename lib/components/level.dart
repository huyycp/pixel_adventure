import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/components/collision_component.dart';
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
  late final TiledComponent component;
  final List<CollisionComponent> collisionComponents = [];

  @override
  FutureOr<void> onLoad() async {
    component = await TiledComponent.load(
      '${world.name}.tmx',
      Vector2.all(16)
    );

    add(component);

    _addSpawnPointsLayer();

    _addCollisionLayer();

    // debugMode = true;

    return super.onLoad();
  }

  void _addSpawnPointsLayer() {
    final spawnPointsLayer = component.tileMap.getLayer<ObjectGroup>(GameLayers.spawnPoints.name);

    if (spawnPointsLayer == null) {
      throw Exception('SpawnPoints layer not found in the map.');
    }

    for (var point in spawnPointsLayer.objects) {
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
  }

  void _addCollisionLayer() {
    final collisions = component.tileMap.getLayer<ObjectGroup>(GameLayers.collisions.name);

    if (collisions == null) {
      throw Exception('Collisions layer not found in the map.');
    }

    for (var point in collisions.objects) {
      final object = enumFromString(GameObjects.values, point.class_, GameObjects.unknown);
      final CollisionComponent component;
      switch (object) {
        case GameObjects.platform:
          component = CollisionComponent(
            position: point.position,
            size: point.size,
            isPlatform: true,
          );
          break;
        default:
          component = CollisionComponent(
            position: point.position,
            size: point.size,
          );
      }
      collisionComponents.add(component);
    }
    addAll(collisionComponents);
    character.collisionComponents = collisionComponents;
  }

}