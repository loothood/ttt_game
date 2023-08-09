import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';

import '../client_constants.dart';
import '../my_game.dart';

class Grid extends PositionComponent with HasGameRef<MyGame> {
  late double cellSize; 
  late double xStartOffset;

  @override
  FutureOr<void> onLoad() {
    cellSize = calculateCellSize(gameRef.canvasSize.x, gameRef.canvasSize.y);
    xStartOffset = gameRef.canvasSize.x / 2 - cellSize * 1.5;
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    cellSize = calculateCellSize(size.x, size.y);
    xStartOffset = size.x / 2 - cellSize * 1.5;
    super.onGameResize(size);
  }

  @override
  void render(Canvas canvas) {
    const Color color = Color(ClientConstants.gridColor);
    for (int i = 0; i <= 3; i++) {
      canvas.drawLine(
          Offset(xStartOffset + i * cellSize, 0),
          Offset(xStartOffset + i * cellSize, cellSize * 5),
          Paint()..color = color);
    }
    for (int i = 1; i <= 5; i++) {
      canvas.drawLine(
          Offset(xStartOffset, cellSize * i),
          Offset(xStartOffset + cellSize * 3, cellSize * i),
          Paint()..color = color);
    }
    super.render(canvas);
  }

  double calculateCellSize(double x, double y) {
    return y / 5 <= x / 3 ? y / 5 : x / 3;
  }
}
