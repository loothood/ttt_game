import '../common/constants.dart';
import 'figure.dart';
import 'figure_type.dart';
import 'winner.dart';

class Board {
  List<Figure> figures;

  Board(this.figures);

  factory Board.fromJson(Map<String, dynamic> json) {
    final List<dynamic> figuresJson = json['figures'];
    final figures =
        figuresJson.map((figureJson) => Figure.fromJson(figureJson)).toList();
    return Board(figures);
  }

  Map<String, dynamic> toJson() => {
        'figures': figures.map((figure) => figure.toJson()).toList(),
      };

  void startnewGame() {
    figures.clear();
    figures.add(const Figure(FigureType.small, Constants.player1Color, 0));
    figures.add(const Figure(FigureType.small, Constants.player1Color, 0));

    figures.add(const Figure(FigureType.medium, Constants.player1Color, 1));
    figures.add(const Figure(FigureType.medium, Constants.player1Color, 1));

    figures.add(const Figure(FigureType.large, Constants.player1Color, 2));
    figures.add(const Figure(FigureType.large, Constants.player1Color, 2));

    figures.add(const Figure(FigureType.small, Constants.player2Color, 12));
    figures.add(const Figure(FigureType.small, Constants.player2Color, 12));

    figures.add(const Figure(FigureType.medium, Constants.player2Color, 13));
    figures.add(const Figure(FigureType.medium, Constants.player2Color, 13));

    figures.add(const Figure(FigureType.large, Constants.player2Color, 14));
    figures.add(const Figure(FigureType.large, Constants.player2Color, 14));
  }

  void removeFigureFromCell(int cellId) {
    final int index = figures
        .indexWhere((Figure figureServer) => figureServer.cellId == cellId);
    if (index != -1) {
      figures.removeAt(index);
    }
  }

  bool canPutFigure(int cellId, FigureType otherFigureType) {
    final Figure figureServer = figures.lastWhere(
        (Figure figureServer) => figureServer.cellId == cellId,
        orElse: () => Constants.noneFigure);
    if (figureServer.figureType == FigureType.none) {
      return true;
    } else if (figureServer.figureType == FigureType.large) {
      return false;
    } else {
      switch (otherFigureType) {
        case FigureType.small:
          return false;
        case FigureType.medium:
          if (figureServer.figureType == FigureType.small) {
            return true;
          } else {
            return false;
          }
        case FigureType.large:
          if (figureServer.figureType == FigureType.small ||
              figureServer.figureType == FigureType.medium) {
            return true;
          } else {
            return false;
          }
        case FigureType.none:
          return true;
      }
    }
  }

  void putFigure(Figure figure) =>
      figures.add(Figure(figure.figureType, figure.color, figure.cellId));

  Winner checkWinner() {
    if (playerWin(Constants.player1Color)) {
      return Winner.top;
    } else if (playerWin(Constants.player2Color)) {
      return Winner.bottom;
    }
    return Winner.none;
  }

  bool playerWin(int playerColor) {
    final List<int> playerCells = <int>[];
    for (final Figure pFigure in figures) {
      final Figure lastFigure = figures
          .where((Figure element) => element.cellId == pFigure.cellId)
          .last;
      if (lastFigure.color == playerColor) {
        playerCells.add(pFigure.cellId);
      }
    }
    for (final List<int> wins in Constants.winnigCombinations) {
      int matchCount = 0;
      for (final int w in wins) {
        if (playerCells.contains(w)) {
          matchCount++;
        }
      }
      if (matchCount == Constants.winningCount) {
        return true;
      }
    }
    return false;
  }
}