import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/character.dart';
import 'package:pixel_adventure/data/constants/game_constants.dart';
import 'package:pixel_adventure/levels/level.dart';

class PixelAdventure extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks {
  late final Character character;
  late final JoystickComponent joystick;
  final bool isJoystickEnabled = true;

  @override
  Future<void> onLoad() async {
    character = Character(GameCharacters.maskDude);
    final level = Level(character: character);
    world = level;
    camera = CameraComponent.withFixedResolution(
      width: size.x,
      height: size.y,
      world: world,
    );

    camera.viewfinder.anchor = Anchor.bottomLeft;
    camera.viewfinder.position = Vector2(0, level.world.height);

    await images.loadAllImages();

    addAll([
      world,
      camera,
    ]);

    if (isJoystickEnabled) {
      addJoystick();
    }

    return super.onLoad();
  } 

  @override
  void update(double dt) {
    if (isJoystickEnabled) updateJoystick();
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(images.fromCache(GameComponents.joystickKnob.path)),
        size: Vector2.all(64),
      ),
      background: SpriteComponent(
        sprite: Sprite(images.fromCache(GameComponents.joystickBackground.path)),
        size: Vector2.all(128),
      ),
      margin: const EdgeInsets.only(left: 80, bottom: 60),
    );

    camera.viewport.add(joystick);
  }

  void updateJoystick() {
    switch(joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        character.direction = GameCharacterDirections.left;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        character.direction = GameCharacterDirections.right;
        break;
      default:
        character.direction = GameCharacterDirections.none;
    }
  }
}