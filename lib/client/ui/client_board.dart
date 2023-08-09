import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../entity/board.dart';
import '../../entity/figure.dart';
import '../../entity/figure_type.dart';
import '../client_constants.dart';
import 'grid.dart';

class ClientBoard extends PositionComponent {
  
  Grid grid = Grid();
  Board board = Board(<Figure>[]);

  @override
  void render(Canvas canvas) {
    for (final Figure figure in board.figures) {
      switch (figure.figureType) {
        case FigureType.small:
          drawFigure(ClientConstants.smallFigureDevider, figure, canvas);
          break;
        case FigureType.medium:
          drawFigure(ClientConstants.mediumFigureDevider, figure, canvas);
          break;
        case FigureType.large:
          drawFigure(ClientConstants.largeFigureDevider, figure, canvas);
          break;
        case FigureType.none:
          break;
      }
    }
    grid.render(canvas);
    super.render(canvas);
  }

  void drawFigure(double devider, Figure figure, Canvas canvas) {
    final Offset cellCenter = cellCenterById(figure.cellId);
    canvas.drawCircle(
        cellCenter, grid.cellSize / devider, Paint()..color = ClientConstants.colorMap[figure.color]!);
    switch (figure.cellId) {
      case 0:
      case 1:
      case 2:
      case 12:
      case 13:
      case 14:
        final int count = board.figures
            .where((Figure element) => element.cellId == figure.cellId)
            .toList()
            .length;
        final TextSpan span = TextSpan(
            style: const TextStyle(color: ClientConstants.textColor, fontSize: ClientConstants.fontSize),
            text: 'x${count.toString()}');
        final TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas,
            Offset(cellCenter.dx - ClientConstants.fontSize / 2, cellCenter.dy - ClientConstants.fontSize / 2));
    }
  }

  Offset cellCenterById(int cellId) {
    final int xFactor = cellId % 3;
    final int yFactor = cellId ~/ 3;
    return Offset(
        xFactor * grid.cellSize + (grid.cellSize / 2) + grid.xStartOffset,
        yFactor * grid.cellSize + (grid.cellSize / 2));
  }

  int cellIdByCoordinates(Vector2 coordinates) {
    final int x = (coordinates.x - grid.xStartOffset) ~/ grid.cellSize;
    final int y = coordinates.y ~/ grid.cellSize;
    return y * 3 + x;
  }

  Figure getFigureByCellId(int cellId) =>
      board.figures.firstWhere((Figure figure) => figure.cellId == cellId,
          orElse: () => ClientConstants.noneFigure);
}