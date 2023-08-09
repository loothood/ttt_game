import 'package:logging/logging.dart';

import '../entity/board.dart';
import '../entity/figure.dart';
import '../entity/figure_type.dart';
import '../entity/game_status.dart';
import '../entity/move.dart';
import '../entity/winner.dart';
import '../common/constants.dart';

class GameState {
  final Logger _log = Logger('Server');
  late String? topPlayerId;
  late String? bottomPlayerId;
  Winner winner = Winner.none;
  bool bottomPlayerTurn = false;
  GameStatus gameStatus = GameStatus(Board(<Figure>[]));

  Move moveFigure(Move move) {
    final FigureType figureType =
        FigureType.values.firstWhere((FigureType e) => e == move.figureType);
    if (move.clientId == topPlayerId && !bottomPlayerTurn ||
        move.clientId == bottomPlayerId && bottomPlayerTurn) {
      bool canPut =
          gameStatus.board.canPutFigure(move.targetCellId, figureType);
      if (canPut) {
        int color = Constants.player1Color;
        bottomPlayerTurn = true;
        if (move.clientId == bottomPlayerId) {
          color = Constants.player2Color;
          bottomPlayerTurn = false;
        }
        gameStatus.board
            .putFigure(Figure(figureType, color, move.targetCellId));
        gameStatus.board.removeFigureFromCell(move.sourceCellId);
        winner = gameStatus.board.checkWinner();
        if (winner == Winner.top) {
          _log.info('Player $topPlayerId win');
          gameStatus.winnerId = topPlayerId;
        } else if (winner == Winner.bottom) {
          _log.info('Player $bottomPlayerId win');
          gameStatus.winnerId = bottomPlayerId;
        }
        move.canPut = true;
      } else {
        move.canPut = false;
      }
    }
    return move;
  }
}