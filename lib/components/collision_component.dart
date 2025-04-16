import 'package:flame/components.dart';

class CollisionComponent extends PositionComponent {
  CollisionComponent({
    super.position,
    super.size,
    this.isPlatform = false,
  });

  final bool isPlatform;
}