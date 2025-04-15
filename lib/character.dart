import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/utils/extensions/string_ex.dart';

class Character extends SpriteAnimationGroupComponent with HasGameRef<PixelAdventure> {
  
  Character(this.character);

  final GameCharacters character;
  
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;

  GameCharacterDirections direction = GameCharacterDirections.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isPacingRight = true;

  @override
  FutureOr<void> onLoad() {
    onLoadAnimation();
    return super.onLoad();
  }

  void onLoadAnimation() {
    idleAnimation = _createAnimation(GameCharacterStates.idle, frameAmount: 11);
    runAnimation = _createAnimation(GameCharacterStates.run, frameAmount: 12);

    animations = {
      GameCharacterStates.idle: idleAnimation,
      GameCharacterStates.run: runAnimation,
    };

    current = GameCharacterStates.idle;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updateCharaterPosition(dt);
  }

  SpriteAnimation _createAnimation(GameCharacterStates state, {required int frameAmount}) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('${character.path}/${state.getPath()}'),
      SpriteAnimationData.sequenced(
        amount: frameAmount,
        stepTime: 0.05,
        textureSize: Vector2.all(32),
      ),
    );
  }

  void _updateCharaterPosition(double dt) {
    switch (direction) {
      case GameCharacterDirections.left:
        if (isPacingRight) {
          isPacingRight = false;
          flipHorizontally();
          flipHorizontallyAroundCenter();
        }
        position.add(Vector2(-moveSpeed * dt, 0));
        current = GameCharacterStates.run;
        break;
      case GameCharacterDirections.right:
        position.add(Vector2(moveSpeed * dt, 0));
        current = GameCharacterStates.run;
        break;
      case GameCharacterDirections.none:
        current = GameCharacterStates.idle;
        break;
    }
  }
}


enum GameCharacters {
  maskDude('mask_dude'),
  ninjaFrog('ninja_frog'),
  pinkMan('pink_man'),
  virtualGuy('virtual_guy');

  const GameCharacters(this.character);
  final String character;

  static const String basePath = 'main_characters';

  String get path => '$basePath/$character';
}

enum GameCharacterStates {
  doubleJump,
  fall,
  hit,
  idle,
  jump,
  run,
  wallJump;

  String getPath({int size = 32}) => '${name.camelToSnake}_${size}x$size.png';
}

enum GameCharacterDirections {
  left,
  right,
  none,
}
