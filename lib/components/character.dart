import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/utils/extensions/string_ex.dart';

class Character extends SpriteAnimationGroupComponent with HasGameRef<PixelAdventure>, KeyboardHandler {
  
  Character(this.character);

  final GameCharacters character;
  
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;

  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();

  /// Value : -1, 0, 1
  /// -1 = left, 0 = none, 1 = right
  int horizontalMovement = 0;

  @override
  FutureOr<void> onLoad() {
    onLoadAnimation();
    return super.onLoad();
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed = 
      keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
      keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRightKeyPressed =
      keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
      keysPressed.contains(LogicalKeyboardKey.keyD);

    if (isLeftKeyPressed && isRightKeyPressed) {
      horizontalMovement = 0;
    } else if (isLeftKeyPressed) {
      horizontalMovement = -1;
    } else if (isRightKeyPressed) {
      horizontalMovement = 1;
    } else {
      horizontalMovement = 0;
    }
    return super.onKeyEvent(event, keysPressed);
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
    _updateCharacterMovement(dt);
    _updateCharacterState(dt);
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

  void _updateCharacterState(double dt) {
    if (velocity.x == 0) {
      current = GameCharacterStates.idle;
    } else {
      final isMovingLeft = velocity.x < 0;
      if (
        (isMovingLeft && scale.x > 0) || 
        (!isMovingLeft && scale.x < 0)
      ) {
        flipHorizontallyAroundCenter();
      }
      current = GameCharacterStates.run;
    }
  }

  void _updateCharacterMovement(double dt) {
    velocity.x = horizontalMovement * moveSpeed;
    position.add(velocity * dt);
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
