import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import '../common/constants.dart';
import '../entity/figure.dart';
import '../entity/figure_type.dart';
import '../entity/message.dart';
import '../entity/move.dart';
import '../entity/player_role.dart';
import 'client_constants.dart';
import 'socket_manager.dart';
import 'ui/client_board.dart';

class MyGame extends FlameGame with MultiTouchTapDetector {
  ClientBoard clientBoard = ClientBoard();
  PlayerRole playerRole = PlayerRole.observer;
  Figure figureInHand = ClientConstants.noneFigure;
  int sourceCellId = Constants.fakeCellId;
  bool canPut = true;
  bool canPlay = false;
  String? winner;

  late SocketManager socketManager;
  late String clientId;

  @override
  Color backgroundColor() => ClientConstants.backgoundColor;

  @override
  FutureOr<void> onLoad() async {
    socketManager = SocketManager(this, Constants.port);
    await socketManager.connectWithReconnect(
        Uri.parse('ws://${Constants.host}:${Constants.port}'),
        Constants.maxAttempts,
        Constants.reconnectDelay);
    return super.onLoad();
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);
    if (playerRole != PlayerRole.observer && canPlay) {
      final int clickedCellId =
          clientBoard.cellIdByCoordinates(info.eventPosition.game);
      final bool wrongCellId = clickedCellAction(clickedCellId);
      if (wrongCellId) {
        return;
      }
      if (figureInHand.figureType != FigureType.none) {
        tryPutFigure(clickedCellId);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    clientBoard.render(canvas);
    if (winner != null) {
      if (winner == clientId) {
        printText(canvas, 'You WIN!', Offset(size.x / 2, size.y / 2));
        canPlay = false;
      } else {
        printText(canvas, 'You LOST!', Offset(size.x / 2, size.y / 2));
        canPlay = false;
      }
    }
  }

  @override
  void onGameResize(Vector2 size) {
    clientBoard.grid.onGameResize(size);
    clientBoard.onGameResize(size);
    super.onGameResize(size);
  }

  bool clickedCellAction(int clickedCell) {
    bool wrongCellId = false;
    switch (clickedCell) {
      case 0:
      case 1:
      case 2:
        if (playerRole != PlayerRole.topPlayer) {
          wrongCellId = true;
        } else {
          wrongCellId = false;
          figureInHand = clientBoard.getFigureByCellId(clickedCell);
          sourceCellId = clickedCell;
        }
        break;
      case 12:
      case 13:
      case 14:
        if (playerRole != PlayerRole.bottomPlayer) {
          wrongCellId = true;
        } else {
          wrongCellId = false;
          figureInHand = clientBoard.getFigureByCellId(clickedCell);
          sourceCellId = clickedCell;
        }
        break;
      default:
        break;
    }
    return wrongCellId;
  }

  void tryPutFigure(int clickedCellId) {
    bool clientCanPut =
        clientBoard.board.canPutFigure(clickedCellId, figureInHand.figureType);
    if (clientCanPut) {
      Move move =
          Move(clientId, sourceCellId, clickedCellId, figureInHand.figureType);
      Message message = Message(MessageType.move, move: move);
      socketManager.send(message);
      if (canPut) {
        figureInHand = ClientConstants.noneFigure;
        sourceCellId = Constants.fakeCellId;
        canPut = false;
      }
    }
  }

  void printText(Canvas canvas, String text, Offset offset) {
    final TextSpan span = TextSpan(
        style: const TextStyle(
            color: ClientConstants.textColor,
            fontSize: ClientConstants.fontSize),
        text: text);
    final TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, offset);
  }
}